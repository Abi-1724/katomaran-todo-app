const mongoose = require('mongoose');

const taskSchema = new mongoose.Schema({
  userId: String,
  title: String,
  description: String,
  dueDate: Date,
  status: { type: String, default: 'open' },
  priority: { type: String, default: 'normal' }
});

module.exports = mongoose.model('Task', taskSchema);
