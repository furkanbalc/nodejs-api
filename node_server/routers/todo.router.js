const router = require('express').Router();
const TodoController = require('../controllers/todo.controller');

router.post('/createTodo',TodoController.createTodo);
router.get('/getTodos',TodoController.getTodos);
router.delete('/deleteTodo/:id',TodoController.deleteTodo);
router.put('/updateTodo/:id',TodoController.updateTodo);
module.exports = router;