#!/usr/bin/env lua

-- mask section of QR centre:
--   convert large.png -fill blue -draw "circle 2024,1518 2024,1818" circ.png

-- reduce contrast (background colour, reduced lighting):
--   convert large.png -brightness-contrast 0,-50 contrast.png
--   convert large.png -brightness-contrast 0,-100 contrast.png

-- brightness, tends to white (sensor saturation, for example):
--   convert large.png -brightness-contrast +50,0 contrast.png

-- rotation
--   convert large.png -rotate 45 rotate.png

-- skew (view angle/printing error)
--

-- perspective (viewing angle)
--   convert test50.png -gravity center -extent 1800x1650 pers-in.png
--   N=100; convert pers-in.png -distort Perspective "275,200 $((275-$N)),200   275,1450 $((275+$N)),1450   1525,1450 $((1525-$N)),1450   1525,200 $((1525+$N)),200" pers.png
--   convert pers.png -gravity center -extent 4048x3036 pers-out.png

--   N=250; convert pers-in.png -distort Perspective "275,200 $((275+$N)),200   275,1450 $((275-$N)),1450   1525,1450 $((1525+$N)),1450   1525,200 $((1525-$N)),200" pers.png

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



---- Main function ----

test_string = "xahvahjahThahza6yu2baiBaiYoogohpu8koorie6ohBee4Phi" .. ""
--	      "e8ahd1Sheidooqu9caocu7ahch4dool0aifai7wies6Shuiqu6"
-- TODO: Randomise, encoded data could affect resillience

qr_large	= "/tmp/qr-100px.png"
qr_med		= "/tmp/qr-50px.png"
qr_small	= "/tmp/qr-20px.png"

-- Settings --
WIKI_PATH = "./qrtest.wiki/"
BLUR_MAX = 15


function run_tests()
	-- Make QR codes
	make_qr(100, test_string, "L", qr_large)  -- large
	make_qr(50,  test_string, "L", qr_med)    -- med
	make_qr(20,  test_string, "L", qr_small)  -- med-small

	os.execute("mkdir -p " .. WIKI_PATH .. "output")

	-- Blur
	for i=0,BLUR_MAX,1 do
		out = "qr-blur-" .. i
		image_test = "/tmp/" .. out .. ".png"
		image_thumb = WIKI_PATH .. "output/" .. out .. "-thumb.png"
		print("blur level " .. i)
		blur(qr_small, image_test, i)
		thumb(image_test, image_thumb)
		os.execute("./qr-decode " .. image_test)
	end
end

run_tests()
