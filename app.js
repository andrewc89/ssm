
import {Server} from "./models/server";

var server = new Server({
    name: "localhost",
    statsFilePath: "\\\\localhost\\c$\\export\\stats.json",
    dbConfig: {
        user: "ssmonitor",
        password: "ssmonitor",
        server: "localhost",
        database: "msdb"
    }
});

server.getJobHistory();
