const jwt = require('jsonwebtoken');

const authMiddleware = async(req , res , next)=>{
    const token = req.headers.token;

    if(!token){
        return res.status(401).json({
            message:"Token is Required"
        });
    }

    try{
        const decoded = jwt.verify(token, process.env.JWT_SECRET)


            req.id = decoded.id;
            req.token = token;
            return next();
            // return res.status(401).json({
            //     message : "Invalid Token , Authorization Denied!!"
            // });

    }catch(error){
        console.error("JWT Verification Error: ", error.message);

        return res.status(401).json({
            message:"Invalid or expired token."
            ,error:error.message
        })
    }

};

module.exports = authMiddleware;