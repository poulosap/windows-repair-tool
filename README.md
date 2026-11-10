# Windows Repair Tool - Compatibility Edition 1.1 Alpha

Experimental alpha for controlled testing. Static-reviewed only; not runtime-tested on Windows. Back up data before use. Do not treat this as a production-validated repair tool.

## Contents
- RunRepairTool.cmd: interactive native Windows repair wrapper.
- README.txt: setup, safety and limitations.
- TEST-PLAN.txt: validation checklist; tests have not been executed.
- .github/ISSUE_TEMPLATE/alpha-test-report.md: tester feedback template.

## Quick start
Download the repository with Code > Download ZIP, extract it into a trusted local folder, and read README.txt. Open Command Prompt as administrator, navigate to that folder and run RunRepairTool.cmd. Inspect option 5 first. Repair operations require explicit confirmation.

## Compatibility
Windows 2000 is the oldest design target, not verified support. XP, Vista, 7, 8/8.1, 10/11 and Server all need runtime validation. Windows 3.x/95/98/Me and offline recovery environments are out of scope. No universal Windows compatibility is claimed.

## Safety and limitations
No third-party downloads, automatic reboot, forced dismount, dirty-bit changes, or automatic process termination. DISM may obtain repair content from Windows Update. Native CHKDSK prompts remain interactive; approving a dismount can interrupt applications. A failing drive should be handled as a data-recovery problem before repair. No custom transcript, pending-reboot detector or automatic disk enumeration is provided.

## Alpha status
This is an alpha source publication, not a formal GitHub Release. Earlier local packaging checks did not execute Windows commands. Current repository contents require their own runtime validation. Report results using the issue template and redact personal information.

## License
No open-source license has been selected. Public visibility alone does not grant an open-source license.
