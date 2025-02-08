require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const authRouter = require('./routes/auth_route');
const taskRouter = require('./routes/task_route');
const app = express();
const PORT = process.env.PORT || 5000;


app.use(cors());
app.use(express.json());



app.use(authRouter);
app.use(taskRouter);

const connectDB = async () =>{
    try {
        if (!process.env.DB_CONNECTION) {
            throw new Error('Missing DB_CONNECTION in environment variables');
        }

        await mongoose.connect(process.env.DB_CONNECTION);

        console.log('✅ Connected to the Database Successfully');
    } catch (error) {
        console.error('❌ Database Connection Error:', error.message);
        process.exit(1); // Exit process if DB connection fails
    }
}

const startServer = async () => {
    await connectDB();
    
    app.listen(PORT, "0.0.0.0", () => {
        console.log(`🚀 Server is running on port: ${PORT}`);
    });
};
startServer();
