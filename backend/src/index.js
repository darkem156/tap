const app = require("./server.js");

//initializing
app.listen(
    app.get('port'), () => {
        console.log('Server on port', app.get('port'));
    }
)
