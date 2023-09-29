const db = require('../config/db');
const mongoose = require('mongoose');

const { Schema } = mongoose;
const todoSchema = new Schema({
    title: {
        type: String,
        required: true
    },
    desc: {
        type: String,
        required: true
    },
    priority: {
        type: Number,
        required: true
    },
},{timestamps:true});

const TodoModel = db.model('todo',todoSchema);
module.exports = TodoModel;