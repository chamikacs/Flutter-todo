import express, { Router } from "express";
import { requireAuth } from "../middleware/AuthMiddleWare.js";
import {
  CreateTodo,
  DeleteTodo,
  GetTodoById,
  GetTodos,
  UpdateTodo,
} from "../controllers/todoController.js";

const todoRouter = express.Router();

todoRouter
  .route("/")
  .post( requireAuth, CreateTodo)
  .get(requireAuth, GetTodos);

todoRouter
  .route("/:id")
  .get(requireAuth, GetTodoById)
  .put(requireAuth, UpdateTodo)
  .delete(requireAuth, DeleteTodo);


export default todoRouter;
