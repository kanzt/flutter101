const express = require('express')
const router = express.Router()
const multer = require('multer')
const multerConfig = require('./config/multer_config')
const upload = multer(multerConfig.config).single(multerConfig.keyUpload)
const db = require('./models')

router.get('/products', async (req, res) => {
    try {
        const result = await db.Products.findAll({
            order: [
                ['id', 'DESC']
            ]
        })
        res.status(200).json(result)
    } catch (error) {
        res.status(500).json({ message: error.message })
    }
})

router.get('/products/:id', async (req, res) => {
    try {
        const result = await db.Products.findByPk(req.params.id)

        if (result) {
            res.status(200).json(result)
        } else {
            res.status(404).json({ message: 'Product not found' })
        }
    } catch (error) {
        res.status(500).json({ message: error.message })
    }
})

router.post('/products', (req, res) => {
    upload(req, res, async (err) => {
        if (err instanceof multer.MulterError) {
            console.log(`error: ${JSON.stringify(err)}`)
            return res.status(500).json({ message: err })
        } else if (err) {
            console.log(`error: ${JSON.stringify(err)}`)
            return res.status(500).json({ message: err })
        }

        const data = {
            ...req.body,
            image: req.file ? req.file.filename : ''
        }

        try {
            const product = await db.Products.create(data)
            res.status(201).json(product)
        } catch (error) {
            res.status(500).json({ message: error.message })
        }
    })
})

router.put('/products/:id', async (req, res) => {
    try {
        const result = await db.Products.findByPk(req.params.id)

        if (!result) {
            return res.status(404).json({ message: 'Product not found' })
        }

        upload(req, res, async (err) => {
            if (err instanceof multer.MulterError) {
                console.log(`error: ${JSON.stringify(err)}`)
                return res.status(500).json({ message: err })
            } else if (err) {
                console.log(`error: ${JSON.stringify(err)}`)
                return res.status(500).json({ message: err })
            }

            const data = {
                ...req.body,
                image: req.file ? req.file.filename : result.image
            }

            try {
                const [updated] = await db.Products.update(data, {
                    where: {
                        id: result.id
                    }
                })

                if (updated) {
                    const updateProduct = await db.Products.findByPk(result.id)
                    res.status(200).json(updateProduct)
                } else {
                    throw new Error('Product not found')
                }
            } catch (error) {
                res.status(500).json({ message: error.message })
            }
        })
    } catch (error) {
        res.status(500).json({ message: error.message })
    }
})

router.delete('/products/:id', async (req, res) => {
    try {
        const deleted = await db.Products.destroy({
            where: {
                id: req.params.id
            }
        })

        if (!deleted) {
            return res.status(404).json({ message: 'Product not found' })
        } else {
            return res.status(204).json({ message: 'Product deleted' })
        }
    } catch (error) {
        res.status(500).json({ message: error.message })
    }
})

module.exports = router