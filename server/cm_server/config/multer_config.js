const multer = require('multer')
const fs = require('fs')

module.exports = multerConfig = {
    config: {
        storage: multer.diskStorage({
            destination: (req, file, next) => {
                const folder = './images/'
                if (!fs.existsSync(folder)) {
                    fs.mkdirSync(folder)
                }
                next(null, folder)
            },
            filename: (req, file, next) => {
                const ext = file.mimetype.split('/')[1]
                next(null, `${file.fieldname}-${Date.now()}.${ext}`)
            }
        }),
        limits: { fileSize: 1024 * 1024 * 5 },
        fileFilter: (req, file, next) => {
            const image = file.mimetype.startsWith('image/')
            if (image) {
                next(null, true)
            } else {
                next({ message: 'File type not supported' }, false)
            }
        }
    },
    keyUpload: 'photo'
}

