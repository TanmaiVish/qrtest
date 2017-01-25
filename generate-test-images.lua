#!/usr/bin/env lua

-- mask section of QR centre:
--   convert large.png -fill blue -draw "circle 2024,1518 2024,1818" circ.png

-- brightness, tends to white (sensor saturation, for example):
--   convert large.png -brightness-contrast +50,0 contrast.png

-- skew (view angle/printing error)
--


-- barrel distortion (fisheye) (lens)
--   convert med.png -implode -0.1 imp.png
--   convert med.png -implode -1 imp.png
--   convert med-small.png -implode -0.5 imp.png

-- sine wave displacement (corrugated)
--   convert large.png -wave 10x64 rotate.png
--   convert large.png -wave 100x64 rotate.png

-- sine wave displacement
--   convert large.png -wave 100x1000 rotate.png
--   convert large.png -wave 10x1000 rotate.png



---- General functions ----

-- TODO returns, error handling, dependency checking

-- Generate QR
--   qrencode lemon-cheese -s 100 -v 2 -o test.png
function make_qr(block_size, data, ecc_level, path)
	os.execute("qrencode " .. data ..
		   " -s " .. block_size ..
		   " -v 2 -l " .. ecc_level ..
		   " -o " .. path)
end

-- Resize canvas
--   convert test.png -gravity center -extent 4048x3036 extent_center.png
function resize_canvas(path, out_path, width, height)
	os.execute("convert " .. path ..
		   " -gravity center -extent " ..
		   width .. "x" .. height .. " " .. out_path)
end

function resize_canonical(path, out_path)
	resize_canvas(path, out_path, 4048, 3036)
end

function thumb(path, out_path)
	os.execute("convert " .. path ..
		   " -thumbnail 1000x500" ..
		   " -unsharp 0x0.5 " .. out_path)
end


---- Distortion functions ----

-- Blur (focus)
--   convert test.png -blur 0x0.5 blur.png
function blur(input, output, amount)
	os.execute("convert " .. input .. " -blur 0x" .. amount .. " " .. output)
end

-- reduce contrast (background colour, reduced lighting):
--   convert large.png -brightness-contrast 0,-50 contrast.png
--   convert large.png -brightness-contrast 0,-100 contrast.png
function reduce_contrast(input, output, amount)
	os.execute("convert ".. input ..
		   " -brightness-contrast 0,-" .. amount .. " " ..
		   output)
end

-- rotation
--   convert large.png -rotate 45 rotate.png
-- TODO: ensure consistent block size across tests
function rotate(input, output, amount)
	os.execute("convert " .. input .." -rotate ".. amount .. " " .. output)

end

-- perspective (viewing angle)
--   convert test50.png -gravity center -extent 1800x1650 pers-in.png
--   N=100; convert pers-in.png -distort Perspective "275,200 $((275-$N)),200   275,1450 $((275+$N)),1450   1525,1450 $((1525-$N)),1450   1525,200 $((1525+$N)),200" pers.png
--   convert pers.png -gravity center -extent 4048x3036 pers-out.png
function perspective(input, output, amount)
	os.execute("convert " .. input ..
		   " -gravity center -extent 1800x1650 /tmp/pers-in.png")
	os.execute("convert /tmp/pers-in.png -distort Perspective '" ..
		   "275,200 "   .. (275-amount)  .. ",200 " ..
		   "275,1450 "  .. (275+amount)  .. ",1450 " ..
		   "1525,1450 " .. (1525-amount) .. ",1450 " ..
		   "1525,200 "  .. (1525+amount) .. ",200 " ..
		   "' " .. output)
end



---- Test functions ----
image_test = ""
image_thumb = ""
path_thumb = ""

function test_start(identifier, level)
	out = "qr-".. identifier .. "-" .. level
	image_test = "/tmp/" .. out .. ".png"
	image_thumb = "output/" .. out .. "-thumb.png"
	path_thumb = WIKI_PATH .. image_thumb
	print("test:\t\t[" .. identifier .. " level " .. level .. "]")
	print("test string:\t[" .. test_string .. "]")
	print("test image:\t[" .. image_test .. "]")
	print("thumb image:\t[" .. image_thumb .. "]")
end

function test_finish()
	thumb(image_test, path_thumb)
	os.execute("./qr-decode " .. image_test)
end

---- Main function ----

test_string = "xahvahjahThahza6yu2baiBaiYoogohpu8koorie6ohBee4Phi" ..
	      "e8ahd1Sheidooqu9caocu7ahch4dool0aifai7wies6Shuiqu6"
-- TODO: Randomise, encoded data could affect resillience

qr_large	= "/tmp/qr-100px.png"
qr_med		= "/tmp/qr-50px.png"
qr_small	= "/tmp/qr-20px.png"

-- Settings --
WIKI_PATH = "./qrtest.wiki/"
BLUR_MAX = 15
RED_CONT_MAX = 100
ROTATE_MAX = 180
PERS_MAX = 250

function run_tests()
	-- Make QR codes
	make_qr(100, test_string, "L", qr_large)  -- large
	make_qr(50,  test_string, "L", qr_med)    -- med
	make_qr(20,  test_string, "L", qr_small)  -- med-small

	os.execute("mkdir -p " .. WIKI_PATH .. "output")

	-- Blur
--[[
	for i=0,BLUR_MAX,1 do
		test_start("blur", i)
		blur(qr_small, image_test, i)
		test_finish()
	end
	for i=0,RED_CONT_MAX,5 do
		test_start("reduce-contrast", i)
		reduce_contrast(qr_med, image_test, i)
		test_finish()
	end
	for i=0,ROTATE_MAX,15 do
		test_start("rotate", i)
		rotate(qr_med, image_test, i)
		test_finish()
	end
--]]
	for i=0,PERS_MAX,10 do
		test_start("perspective", i)
		perspective(qr_small, image_test, i)
		test_finish()
	end

end

run_tests()

-- TODO: reduce granularity, only report failures?
