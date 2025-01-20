const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    await mongoose.connect(
      'mongodb+srv://jimmy551:myPassword@test.rndif.mongodb.net/Test?retryWrites=true&w=majority',
      { useNewUrlParser: true, useUnifiedTopology: true }
    );
    console.log('MongoDB Connected...');
  } catch (err) {
    console.error('Error connecting to MongoDB:', err.message);
    process.exit(1);
  }
};

module.exports = connectDB;
