import express from "express";
import dotenv from "dotenv";
import connectDB from "./config/db.js";
import authRouter from "./routes/authRoutes.js";
import todoRouter from "./routes/todoRoutes.js";

dotenv.config();
const port = process.env.PORT || 5555;

connectDB();

const app = express();

app.use(express.json());
// app.use(express.urlencoded({ extended: true }));
app.use("/api/auth", authRouter);
app.use("/api/todos", todoRouter);

app.listen(port, () => console.log(`Server running on port: ${port}`));
