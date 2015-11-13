
import {spawn} from "child_process";
import * as sql from "../utils/sqlagent";

export class Server {
    constructor(data) {
        this.name = data.name;
        this.statsFilePath = data.statsFilePath;
        this.dbConfig = data.dbConfig;
    }
    getStats(cb) {
        let child = spawn("../scripts/readData.cmd", [this.statsFilePath]);
        child.stdout.on("data", cb);
    }
    getJobHistory(cb) {
        sql.getJobHistory(this.dbConfig, jobs => {
            jobs.forEach(job => {
                console.log(job);
            })
        });
    }
}
