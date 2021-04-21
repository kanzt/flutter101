const express = require('express')
const cors = require('cors')
const app = express()

app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: false }))
app.use(require('./controller'))
app.use('/images', express.static('images'))

// npx cross-env PORT=1112 ENV=production node server.js
const PORT = process.env.PORT || 1150
const ENV = process.env.ENV || 'development'
app.listen(PORT, () => {
    console.log(`App listening on port ${PORT}`);
    console.log(`App listening on env ${ENV}`);
    console.log('Press Ctrl+C to quit.');
})

