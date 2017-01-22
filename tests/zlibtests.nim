import unittest
import ../zip/zlib
from strutils import repeat

test "test stream compression":
    # pangramms
    let text = "The quick brown fox jumps over the lazy dog"
    let text2 = "Portez ce vieux whisky au juge blond qui fume"
    let text3 = "Съешь ещё этих мягких французских булок, да выпей чаю"
    # generated from text with python3.6 zlib module
    # import zlib                       #         GZIP   | ZLIB | RAW
    # z = zlib.compressobj(wbits=WBITS) # WBITS = (16+15 | 15   | -15 )
    # print repr(z.compress(text)+z.flush())
    let raw_deflate = "\x0b\xc9HU(,\xcdL\xceVH*\xca/\xcfSH\xcb\xafP\xc8*\xcd-(V\xc8/K-R(\x01J\xe7$VU*\xa4\xe4\xa7\x03\x00"
    let gzip_deflate = "\x1f\x8b\x08\x00\x00\x00\x00\x00\x00\x03\x0b\xc9HU(,\xcdL\xceVH*\xca/\xcfSH\xcb\xafP\xc8*\xcd-(V\xc8/K-R(\x01J\xe7$VU*\xa4\xe4\xa7\x03\x009\xa3OA+\x00\x00\x00"
    let zlib_deflate = "x\x9c\x0b\xc9HU(,\xcdL\xceVH*\xca/\xcfSH\xcb\xafP\xc8*\xcd-(V\xc8/K-R(\x01J\xe7$VU*\xa4\xe4\xa7\x03\x00[\xdc\x0f\xda"

    # zlib stream of text2.
    let zlib_deflate2 = "x\x9c\x0b\xc8/*I\xadRHNU(\xcbL-\xadP(\xcf\xc8,\xce\xaeTH,U\xc8*MOUH\xca\xc9\xcfKQ(,\xcdTH+\xcdM\x05\x00\x81!\x10\xa9"

    # zlib stream of text3. (encoded with UTF-8)
    let zlib_deflate3 = "x\x9c-\xc8\xeb\x11CP\x18\x06\xe1V\xbe\x02Rd\xc4\x9d`\x94\xa0\x83\xe3r&\x08\xd2\xc2\xbe\x1d1&\xbfv\x9e\xa5S\x81W\xa6\xb7]\xc9\xd5\x9a*\xbd\x98\x15\x1b\x9b\x1aF\xd6\x1b\x8a\xf4\xc4\xb1+Q\xc8G\xc1\x7f\xd3_\xfcr\xb0>\x8c\tg\x0c*\xf9\xe1YL)N\xf5\t_\x12@\xa8"

    check uncompress(compress(text)) == text
    check uncompress(compress(text, stream=RAW_DEFLATE), stream=RAW_DEFLATE) == text
    check uncompress(compress(text, stream=ZLIB_STREAM), stream=ZLIB_STREAM) == text
    check uncompress(compress(text, stream=GZIP_STREAM), stream=GZIP_STREAM) == text
    check uncompress(compress(text, stream=ZLIB_STREAM), stream=DETECT_STREAM) == text
    check uncompress(compress(text, stream=GZIP_STREAM), stream=DETECT_STREAM) == text
    check compress(text, stream=RAW_DEFLATE) == raw_deflate
    check compress(text, stream=GZIP_STREAM) == gzip_deflate
    check compress(text, stream=ZLIB_STREAM) == zlib_deflate

    # check support for concatenated gzip & zlib streams
    check uncompress(gzip_deflate.repeat(5)) == text.repeat(5)
    check uncompress(zlib_deflate.repeat(5)) == text.repeat(5)
    check uncompress(zlib_deflate & zlib_deflate2 & zlib_deflate3) == text & text2 & text3

    # generated from array of 160000 zero bytes with 100 random bytes
    let encoded_data = "x\x9c\xed\xdc?\xa8Nq\x1c\xc7\xf1\xbb\xc8\x9f\xe8\x96L\xca\xcc@J,\xfed\xf1\xa7,&J\x06)\x9b2*d0P\xb7d\xb0\x1aE\xb2(\xd9L\xbaw\xd0\x9d\xc4b\xb8\x19\xc4\xa0\x1b\x06I\x922(u\xf3\xdc\xfb<\xcf}\x9es>\xe7\xf7\xfc^\xaf\xf1W\xe7\xf7}O\xa7\xdf\xa9s\xce\xd4\x140\xbc\xe9t\x00\x00\x00@7}\x0b\xcf?\x1e\x9e\xcf\xea\xf5}\xd4^\xdfF\x05\xd4\xe4e\xcf\xd5\x1d-W\x00P\x80\x8d\xbd\x16\xd7\xb6]\x01\x14\xe9~:\x00\x00\x00\xba\xe5t:\x00\xdaq5\x1d\x00\x00\x0c\xecW:\x00\xa8\xd2\xc9t\xc0\xc8>\x9fI\x174\xe5b:\x00\x00\x00\x00\x00\x18\xc1\\:\xa0a\xfb\xd2\x01\x00\x00\xd0\xcf\x9at@\xa9\x0e\xad\xee\xb27\xe3\xad\x00\x00\x00\x00\x00\x00\xa0Vo\xd3\x01\x00@=\x1e\xa7\x03\x00\x00\x00\x00\x00&\xd5L:\xa0\x97\xcd\xe9\x00\x80\xce8\x95\x0e\x00\x80\x1a\xcd\xa6\x03\x00\x00\x00\xe8\xac\xa3\xe9\x00\x00\x00\x80%^\xa5\x03\x00\x00\x00\x80\xa4\xd7\xe9\x00\x00\x80\x95\xfdH\x07\x00@U\x9e\xa5\x03\x00\x00\x8a\xb3\x98\x0eX\xeaw:\x00\xa0\xe3\x1e\xa5\x03\xa0C\x16Bs?\x84\xe6\x02\x00t\xcf|:\xa0E\x17\xd2\x01\x00\x00\x00\x00\x00\xd4\xe0S:\x00\x00\x00\x80\xc9\xf5 \x1d\x00\x00\x00ex2\xf2\x0e;\xc7P\x01\x00\xc0\xa8\x0e\xa6\x03\x00\xe8\xb2\xeb\xe9\x00\xfa:\x91\x0e\x00\x96s;\x1d@=\xae\xa5\x03\xfes+\x1d\x00\x00\x00@\xd3\xf6\xa7\x03\x00`%\x0f\xd3\x01\x00\x00P\xb2/\xe9\x00\x00\xf8\xebf:\x00\xba\xe0R:\x00\x80\xa1-\xf6X{\xdez\x05\x00\xb4\xc4O\xe4\xa0.\xef\xd2\x01\x00\x00\x00\xb0=\x1d@\xde\xe1t\x00\xe3\xb5)\x1d\x00\x14\xaa\xd7\xdb\x19P\xb3c\xe9\x00\x00rn\xa4\x03\x00\x80&mM\x07\x00\x00\x00\xfcs>\x1d\x00\x00\x00\x00Tn:\x1d\x90\xb4%\x1d@\x95^\xa4\x03\x80\xa6\x1c\x18\xfb\x8eO\xc7\xbe#\xb4l.\x1d@\x87\x9cK\x07\x94\xe3g:\x00\x80I\xf1>\x1d\x00\x00\xc0`\xce\xa6\x03\x00\xa0xw\xd2\x01\x00\x00\x00\x000\x8c+\xe9\x00\xa0\\\x1b\xd2\x01\x00\x00\x00\x00\x0clO:\x00\x00\xc6l6\x1d\x00\x00t\xd3L:\x00\x00\xa0y\x1f\xd3\x01\x00P\x96\xaf\xe9\x00\x00`<v\xa5\x03\x9a4\x9f\x0e\xa8\xc7\xf7t\x00}\xdcM\x07\xd4\xa5\x83\xf7\x9e#\xe9\x00\x80\xf2mK\x07\x00\x00\x00\x00#Y\x97\x0e\x00h\xd0\xde\x16g\xddkq\x16\x00\x00\xc0\xc4\xb8\x9c\x0e(\xd5\xeet\x00\x00P\xb4\x85t\x00\x8d\xe8\xe07;\xcb\x19\xe88\xfb\x07Q12\xb7"

    # check support for uncompression for large array
    check uncompress(encoded_data).len == 160000

