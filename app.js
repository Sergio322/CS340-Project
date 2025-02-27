// App.js

/*
    SETUP
*/

// Database
var express = require('express');   // We are using the express library for the web server
var app     = express();            // We need to instantiate an express object to interact with the server in our code
var db = require('./database/db-connector')
const { engine } = require('express-handlebars');
var exphbs = require('express-handlebars');     // Import express-handlebars
app.engine('.hbs', engine({extname: ".hbs"}));  // Create an instance of the handlebars engine to process templates
app.set('view engine', '.hbs');                 // Tell express to use the handlebars engine whenever it encounters a *.hbs file.

CONST PORT = process.env.PORT || 19922;              // Set a port number at the top so it's easy to change in the future

/*
    ROUTES
*/

// app.js
app.get('/', function(req, res) {
    let query = "SELECT subscriptionID, customerID, serviceID, startDate, endDate FROM Subscriptions"; // Match table & column names

    db.pool.query(query, function(error, results, fields) {
        if (error) {
            console.error("Error executing query:", error);
            res.status(500).send("Database error");
            return;
        }
        
        res.render('index', { subscriptions: results }); // Pass subscriptions to Handlebars template
    });
});

app.use(express.urlencoded({ extended: true })); // Middleware to parse form data

app.post('/update-subscription', function(req, res) {
    let { subscriptionID, startDate, endDate } = req.body;

    // If endDate is empty, set it to NULL
    if (endDate === '') {
        endDate = null;
    }

    let query = "UPDATE Subscriptions SET startDate = ?, endDate = ? WHERE subscriptionID = ?";
    let values = [startDate, endDate, subscriptionID];

    db.pool.query(query, values, function(error, results, fields) {
        if (error) {
            console.error("Error updating subscription:", error);
            res.status(500).send("Database error");
            return;
        }

        res.redirect('/'); // Refresh the page to show updated data
    });
});

app.post('/delete-subscription', function(req, res) {
    let { subscriptionID } = req.body;

    let query = "DELETE FROM Subscriptions WHERE subscriptionID = ?";
    let values = [subscriptionID];

    db.pool.query(query, values, function(error, results, fields) {
        if (error) {
            console.error("Error deleting subscription:", error);
            res.status(500).send("Database error");
            return;
        }

        res.redirect('/'); // Refresh the page to show the updated table
    });
});

app.post('/create-subscription', function(req, res) {
    let { customerID, serviceID, startDate, endDate } = req.body;

    // If endDate is empty, set it to NULL
    if (endDate === '') {
        endDate = null;
    }

    let query = "INSERT INTO Subscriptions (customerID, serviceID, startDate, endDate) VALUES (?, ?, ?, ?)";
    let values = [customerID, serviceID, startDate, endDate];

    db.pool.query(query, values, function(error, results, fields) {
        if (error) {
            console.error("Error inserting subscription:", error);
            res.status(500).send("Database error");
            return;
        }

        res.redirect('/'); // Refresh page to show the new subscription
    });
});


/*
    LISTENER
*/

app.listen(PORT, function(){            // This is the basic syntax for what is called the 'listener' which receives incoming requests on the specified PORT.
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.')
});
