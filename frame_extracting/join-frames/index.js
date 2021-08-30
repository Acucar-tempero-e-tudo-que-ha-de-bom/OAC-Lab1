// const { createCanvas, loadImage } = require('canvas')

const { readFile, writeFile, open } = require('fs/promises')
const { join: pathJoin } = require('path')
const { Buffer } = require('buffer')

const decodeBmp = require('decode-bmp')

const folderPath = pathJoin(__dirname, '../', 'bmp-frames-jap')

const FRAME_COUNT = 5477 // 5477

async function init () {
  const filehandle = await open('teste.bin', 'w')
  let position = 0

  for (let i = 0; i < FRAME_COUNT; i++) {
    const fileName = pathJoin(folderPath, (i + 1).toString().padStart(3, '0') + '.bmp')

    const image = decodeBmp(await readFile(fileName))

    const buf = Buffer.alloc(image.data.byteLength / 4)

    let index = 0
    for (let j = 0; j < image.data.byteLength; j += 4) {
      r = image.data[j]
      g = image.data[j + 1]
      b = image.data[j + 2]

      rq = Math.round(7 * (r / 255))
      gq = Math.round(7 * (g / 255))
      bq = Math.round(3 * (b / 255))

      hex = bq << 6 | gq << 3 | rq

      buf.writeUInt8(hex, index)
      index++
    }

    await filehandle.write(buf, 0, buf.byteLength, position)
    position += buf.byteLength

    console.log('wrote', i)
  }

  console.log('done')
}

init().catch(console.error)
