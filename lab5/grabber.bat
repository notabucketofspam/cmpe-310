@echo off
CALL mexec "./shover.sh"
pscp OCI2:/home/opc/cmpe-310/lab5/report.txt .
timeout /t 10
