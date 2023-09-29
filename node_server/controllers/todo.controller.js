const TodoModel = require('../models/todo.model');
const TodoService = require('../services/todo.services');

// add todo
exports.createTodo = async (req, res) => {
    const { title, desc, priority } = req.body;
    try {
      const todo = await TodoService.createTodo(title, desc, priority);
      res.status(201).json(todo);
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
};
// list to todo
exports.getTodos = async (req, res) => {
    try {
      const todos = await TodoService.getTodos();
      res.json(todos);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
};
// delete todo
exports.deleteTodo = async (req, res) => {
    const { id } = req.params;
    try {
      const todo = await TodoService.deleteTodo(id);
      if (!todo) {
        return res.status(404).json({ error: 'ToDo öğesi bulunamadı' });
      }
      res.json({ message: 'ToDo öğesi başarıyla silindi' });
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
};

// update todo
exports.updateTodo = async (req, res) => {
    const { id } = req.params;
    const { title, desc, priority } = req.body;
    try {
      const todo = await TodoService.updateTodo(id, title, desc, priority);
      if (!todo) {
        return res.status(404).json({ error: 'ToDo öğesi bulunamadı' });
      }
      res.json(todo);
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
};