const Task = require('../models/Task');

exports.getTasks = async (req, res) => {
  try {
    const tasks = await Task.find({ userId: "test-user-id" }); // ✅ use dummy id
    res.json(tasks);
  } catch (err) {
    console.error("❌ Fetch tasks failed:", err);
    res.status(500).json({ error: 'Failed to fetch tasks' });
  }
};


exports.createTask = async (req, res) => {
  try {
    const newTask = new Task({ 
      ...req.body, 
      userId: "test-user-id" // ✅ add dummy userId for testing
    });
    await newTask.save();
    res.status(201).json(newTask);
  } catch (err) {
    console.error("❌ Task creation failed:", err); // ✅ show actual error
    res.status(500).json({ error: 'Failed to create task' });
  }
};


exports.updateTask = async (req, res) => {
  try {
    const updated = await Task.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(updated);
  } catch (err) {
    res.status(500).json({ error: 'Failed to update task' });
  }
};

exports.deleteTask = async (req, res) => {
  try {
    await Task.findByIdAndDelete(req.params.id);
    res.status(204).end();
  } catch (err) {
    res.status(500).json({ error: 'Failed to delete task' });
  }
};
