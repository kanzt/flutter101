'use strict'

module.exports = {
  up: (queryInterface, Sequelize) => {
    data.map(item=>{
      item.created_at = new Date()
      item.updated_at = new Date()
    })

    return queryInterface.bulkInsert('Products', data, {})
  },

  down: (queryInterface, Sequelize) => {
    return queryInterface.bulkDelete('Products', null, {})
  }
}

const data = [
  {
    "name": "Arduino Sensor Kit V5.0",
    "image": "product_10.jpg",
    "stock": 13,
    "price": 150
  },
  {
    "name": "4-Channel 5VDC Relay Module Relay Active High / LOW",
    "image": "product_02.jpg",
    "stock": 1,
    "price": 185
  },
  {
    "name": "4-Channel 5VDC Relay Module Relay Active High / LOW",
    "image": "product_01.jpg",
    "stock": 1,
    "price": 185
  },
  {
    "name": "4-Channel 5VDC Relay Module Relay Active High / LOW",
    "image": "product_07.jpg",
    "stock": 1,
    "price": 185
  },
  {
    "name": "Arduino MEGA 2560 R3 ใช้ชิฟ USB CH340 รุ่นใหม่ แถมสาย USB",
    "image": "product_05.jpg",
    "stock": 100,
    "price": 200
  },
  {
    "name": "Arduino Nano 3.0 Mini USB รุ่นใหม่ใช้ชิฟ CH340G แถมสาย Mini USB",
    "image": "product_23.jpg",
    "stock": 2,
    "price": 130
  },
  {
    "name": "Arduino ProtoShield Mini UNO Prototype Shield พร้อม Mini Breadboard",
    "image": "product_12.jpg",
    "stock": 100,
    "price": 60
  },
  {
    "name": "WeMos D1 R2 WiFi ESP8266 Development Board Compatible Arduino UNO",
    "image": "product_21.jpg",
    "stock": 100,
    "price": 370
  },
  {
    "name": "Arduino UNO R3 แถมสาย USB Type A Male/B Male Cable",
    "image": "product_04.jpg",
    "stock": 1000,
    "price": 300
  },
  {
    "name": "Raining Sensor",
    "image": "product_16.jpg",
    "stock": 1000,
    "price": 300
  },
  {
    "name": "NodeMCU32",
    "image": "product_17.jpg",
    "stock": 1000,
    "price": 300
  },
  {
    "name": "IR Flame Detector Module (ตรวจจับเปลวไฟด้วย Infrared)",
    "image": "product_19.jpg",
    "stock": 60,
    "price": 100
  },
  {
    "name": "IR Flame Detector Module (ตรวจจับเปลวไฟด้วย Infrared)",
    "image": "product_20.jpg",
    "stock": 100,
    "price": 290
  },
  {
    "name": "DotMatrix LED Display",
    "image": "product_14.jpg",
    "stock": 1000,
    "price": 300
  },
  {
    "name": "DHT 22 - Temp. Sensor",
    "image": "product_15.jpg",
    "stock": 1000,
    "price": 300
  },
  {
    "name": "Arduino Sensor Shield V5.0",
    "image": "product_11.jpg",
    "stock": 100,
    "price": 150
  },
  {
    "name": "NodeMCU Development Kit V2 แถมสาย USB (Node MCU)",
    "image": "product_22.jpg",
    "stock": 0,
    "price": 280
  }
]