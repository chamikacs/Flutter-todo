import express from "express";
import dotenv from "dotenv";
import connectDB from "./config/db.js";
import authRouter from "./routes/authRoutes.js";
import todoRouter from "./routes/todoRoutes.js";
import bodyParser from "body-parser";

dotenv.config();
const port = process.env.PORT || 5555;
const jsonparser = bodyParser.json({limit: '10mb'})

connectDB();

const app = express();

app.use(jsonparser)
app.use(express.json());
// app.use(express.urlencoded({ extended: true }));
app.use("/api/auth", authRouter);
app.use("/api/todos", todoRouter);

app.listen(port, () => console.log(`Server running on port: ${port}`));
