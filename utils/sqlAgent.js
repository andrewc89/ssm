
import * as sql from "mssql";

const query = "exec get_job_history";

const statuses = [ "Failed", "Succeeded", "Retry", "Cancelled", "In Progress" ];

export function getJobHistory(cfg, cb) {
    const conn = new sql.Connection(cfg, err => {
        if (err) {
            console.log(err);
            return;
        }
        const req = conn.request();
        req.query(query, (err, records) => {
            if (err) {
                console.log(err);
                return;
            }
            records.forEach(row => {
                row.status = statuses[row.status];
            });
            cb(records);
        });
    });

    conn.on("error", err => {
        console.log(err);
    });
}
