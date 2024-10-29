import express, { Router } from "express";
import { requireAuth } from "../middleware/AuthMiddleWare.js";
import {
  CreateTodo,
  DeleteTodo,
  GetTodoById,
  GetTodos,
  UpdateTodo,
} from "../controllers/todoController.js";
import multer from "multer";

import path from "path";
const todoRouter = express.Router();

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/");
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname)); // unique filename
  },
});
const upload = multer({ storage });

todoRouter
  .route("/")
  .post(upload.single("image"), requireAuth, CreateTodo)
  .get(requireAuth, GetTodos);

todoRouter
  .route("/:id")
  .get(requireAuth, GetTodoById)
  .put(requireAuth, UpdateTodo)
  .delete(requireAuth, DeleteTodo);

// todoRouter.get("/", requireAuth, FilterTodos)

export default todoRouter;
