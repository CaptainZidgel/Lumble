local ffi = require("ffi")
local stb = require("lumble.vorbis")
local socket = require("socket")

local new = ffi.new

local STREAM = {}
STREAM.__index = STREAM

local function AudioStream(file)
	local err = new('int[1]')
	local vorbis = stb.stb_vorbis_open_filename(file, err, nil)

	if err[0] > 0 then return nil, err[0] end

	return setmetatable({
		vorbis = vorbis,
		volume = 0.25,
		samples = stb.stb_vorbis_stream_length_in_samples(vorbis),
		info = stb.stb_vorbis_get_info(vorbis),
		buffer = {},
		loops = 0,
		frames_to_fade = 0,
		frames_faded_left = 0,
	}, STREAM)
end

function STREAM:getSampleCount()
	return self.samples
end

function STREAM:getInfo()
	return self.info
end

function STREAM:streamSamples(duration)
	local frame_size = self.info.sample_rate * duration / 1000
	self.buffer[frame_size] = self.buffer[frame_size] or ffi.new('float[?]', frame_size)

	local samples = self.buffer[frame_size]

	local num_samples = stb.stb_vorbis_get_samples_float_interleaved(self.vorbis, 1, samples, frame_size)

	local fade_percent = 1

	if num_samples < frame_size and self.loops > 1 then
		self.loops = self.loops - 1
		self:seek("start")
	end

	for i=0,num_samples-1 do
		if self.frames_to_fade > 0 then
			if self.frames_faded_left > 0 then
				self.frames_faded_left = self.frames_faded_left - 1
				fade_percent = self.frames_faded_left / self.frames_to_fade
			else
				self:seek("end")
				return nil, 0
			end
		end

		samples[i] = samples[i] * self.volume * fade_percent -- * 0.5 * (1+math.sin(2 * math.pi * 0.1 * socket.gettime()))
	end

	return samples, num_samples
end

function STREAM:setVolume(volume)
	self.volume = volume
end

function STREAM:fadeOut(time)
	self.frames_to_fade = self.info.sample_rate * (time or 1)
	self.frames_faded_left = self.frames_to_fade
end

function STREAM:getVolume()
	return self.volume
end

function STREAM:loop(count)
	self.loops = count or 0
end

function STREAM:seek(pos)
	if pos == "start" then
		stb.stb_vorbis_seek_start(self.vorbis)
	elseif pos == "end" then
		stb.stb_vorbis_seek(self.vorbis, self.samples)
	else
		stb.stb_vorbis_seek(self.vorbis, pos)
	end
end

function STREAM:close()
	stb.stb_vorbis_close(self.vorbis)
end
STREAM.__gc = STREAM.close

return AudioStream