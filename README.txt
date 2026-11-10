WINDOWS REPAIR TOOL - COMPATIBILITY EDITION 1.1 ALPHA

STATUS
Static-reviewed only. Not executed on Windows. Windows 2000 is a design target, not verified compatibility. All desktop and Server combinations need testing. Windows 3.x/95/98/Me, offline Windows repair and recovery environments are out of scope.

SETUP
1. Extract the repository ZIP into a local folder you control.
2. Read this document and TEST-PLAN.txt.
3. Back up important data and use reliable power.
4. Open Command Prompt as administrator on UAC-enabled Windows. On legacy Windows use an Administrator account. Permission is not auto-detected.
5. Navigate to the folder and run RunRepairTool.cmd.
6. Inspect option 5 before choosing operations.
No installation, PowerShell or execution-policy bypass is needed. No automatic elevation or restart is performed.

SECURITY REVIEW
Best-effort static review found no intentional downloader, credential theft or backdoor in this replacement; this is not a guarantee of safety. Native repair commands run with the caller's permissions and can modify system files and filesystems. Run only on systems you administer. Keep the script in a trusted folder and use a trusted operating environment. Menu input uses delayed expansion; disk letters use a fixed A-Z allowlist. These controls require runtime adversarial-input testing. No third-party implementation code was copied and no third-party packages are required.

SAFETY
Do not substitute repair for backup or hardware diagnostics. If a drive is failing, prioritize imaging/recovery before filesystem changes. CHKDSK /r includes /f and can take hours. Read native prompts carefully, including offers to dismount or schedule checks. This tool does not automatically approve them. No process is killed for running too long. No dirty-bit changes, BootExecute edits, chkntfs resets or forced restarts.

BEHAVIOR
Uses cmd.exe built-ins and native system-directory tools. DISM RestoreHealth is enabled only when its help advertises it. A failed help probe can disable DISM even on a capable system; start elevated. Missing FINDSTR disables only the DISM probe. SFC can require installation media. DISM can use Windows Update or need matching repair content. Nonzero DISM results require opt-in before SFC. Native output remains visible. Tool presence and exit codes do not prove complete system health. CHKDSK may reject missing, encrypted, unsupported or network volumes.

LOGS AND LIMITATIONS
No custom transcript, progress parser, disk enumeration or reboot-pending detector. Where provided by Windows, consult %windir%\Logs\CBS\CBS.log and %windir%\Logs\DISM\dism.log. Legacy systems differ. Read native output.

DEPLOYMENT
Portable manual use only. No unattended fleet deployment. Removing the folder removes this wrapper but does not undo repairs. Source is published as an unverified alpha, not a formal prerelease or production-supported release.

LICENSE
No open-source license has been selected. No rights in the original attachments are asserted.
