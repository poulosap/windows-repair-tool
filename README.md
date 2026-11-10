# Windows Repair Tool - Compatibility Edition 1.1 Alpha

Experimental alpha for controlled testing. Static-reviewed only; not runtime-tested on Windows. Back up data before use. Do not treat this as a production-validated repair tool.

## What this tool does
This is an interactive command-script wrapper around Windows' own repair utilities. It presents a menu, asks for confirmation, launches a selected native command, and leaves that command's output visible. It does not implement its own repair engine or guarantee recovery.

### Menu options
| Option | Action | Important distinction |
| --- | --- | --- |
| 1 | Runs DISM RestoreHealth when detected, then SFC /scannow | Can modify Windows files; not a read-only diagnostic. |
| 2 | Runs CHKDSK for the selected drive without repair switches | Reports disk status without requesting filesystem repair. |
| 3 | Runs CHKDSK /f for the selected drive | Requests filesystem repairs; locking or restart-time checking may be needed. |
| 4 | Runs CHKDSK /r for the selected drive | Includes filesystem repair and additional sector recovery work; can take many hours. |
| 5 | Displays Windows version, system paths and detected tools | Does not run a repair or establish system health. |
| 6 | Exits the wrapper | Does not restart Windows. |

DISM services the running Windows image's component store, which Windows uses for servicing and repair. SFC checks protected system files and attempts repairs. CHKDSK checks a volume's filesystem; its purpose differs from repairing Windows components. None of these commands is a substitute for backup or a guarantee that failing hardware is healthy.

## How the script works
1. Initializes a local command environment and resolves tool paths. It prefers Sysnative when that path is exposed to a 32-bit launcher on 64-bit Windows.
2. Searches installed DISM help for /RestoreHealth. This is a capability hint, not a successful repair test. Missing tools or a failed probe disable this step.
3. Displays warnings and waits for a menu choice. Opening the wrapper does not automatically start repairs, although the DISM help probe runs at startup.
4. Requires REPAIR for system-file repair, or a single A-Z drive letter followed by RUN for disk operations. Confirmation tokens are case-sensitive; drive letters are not.
5. Shows the native utility's output and captures its exit code immediately. If DISM returns nonzero, SFC requires a separate explicit confirmation.
6. Returns to the menu after operations. No automatic reboot or forced dismount is requested by the wrapper. Native disk prompts still need careful attention.

## Reading the script
Comments begin with rem and explain intent; labels beginning with a colon mark destinations for goto. The script uses labels rather than recursive menu calls.

| Section or label | Responsibility |
| --- | --- |
| Initialization | Local variables, command extensions, delayed expansion and tool paths. |
| Capability probe | Detects whether DISM help advertises RestoreHealth. |
| :startup | Displays warnings and version information. |
| :menu | Reads a choice and routes to the selected workflow. |
| :systemrepair | Requires explicit consent and chooses the DISM/SFC path. |
| :dismrepair | Runs DISM and handles nonzero results conservatively. |
| :sfcrepair and :nosfc | Runs SFC or reports the missing executable. |
| :diskcheck, :diskfix, :diskrecover | Select fixed CHKDSK arguments, not user-supplied switches. |
| :selectdrive | Validates one drive letter against a fixed allowlist. |
| :diskconfirm | Confirms the target, runs CHKDSK and displays its result. |
| :invaliddrive and :nochkdsk | Handle invalid letters and missing CHKDSK. |
| :information | Reports environment and detected capabilities. |
| :unsupported and :finish | Explain the platform limitation and exit. |

Key variables: TOOLS stores the tool directory; HAS_DISM_HEALTH records the help-probe result; MENU and CONFIRM store responses; DRIVE stores the validated letter; DISK_ARGS contains only a fixed empty value, /f or /r; RESULT stores the preceding command's exit code. Delayed expansion uses exclamation marks to read current values, including values inside command blocks. Input-handling safety still requires the adversarial tests in TEST-PLAN.txt.

## Contents
- RunRepairTool.cmd: annotated interactive repair wrapper.
- README.txt: setup, safety and limitations.
- TEST-PLAN.txt: validation checklist; tests have not been executed.
- .github/ISSUE_TEMPLATE/alpha-test-report.md: tester feedback template.

## Quick start
Download the repository with Code > Download ZIP, extract it into a trusted local folder, and read README.txt. Open Command Prompt as administrator, navigate to that folder and run RunRepairTool.cmd. Inspect option 5 first. Repair operations require explicit confirmation.

## Understanding results
Read the native command output, not just the number printed by the wrapper. SFC's exit code alone is not used to diagnose the system. Nonzero DISM output may require a restart, a matching repair source or troubleshooting before continuing. CHKDSK has its own exit-code meanings; code 1 indicates errors were found and fixed, not simply failure. The wrapper does not verify that a boot-time check was actually scheduled.

## Compatibility
Windows 2000 is the oldest design target, not verified support. XP, Vista, 7, 8/8.1, 10/11 and Server all need runtime validation. Windows 3.x/95/98/Me and offline recovery environments are out of scope. No universal Windows compatibility is claimed. The Windows_NT environment check is only a coarse guard, not a minimum-version verification.

## Safety review and limitations
Best-effort static review is not a security certification. Native repair commands inherit the caller's privileges and can modify system files and filesystems. Keep this script and its operating environment trusted.

No third-party downloads, automatic reboot, wrapper-forced dismount, dirty-bit changes, or automatic process termination. DISM may obtain repair content from Windows Update. Native CHKDSK prompts remain interactive; approving a dismount can interrupt applications. A failing drive should be handled as a data-recovery problem before repair. No custom transcript, pending-reboot detector or automatic disk enumeration is provided. Administrator access is not automatically checked or requested. Tool detection does not establish that a selected operation will work.

## Alpha status
This is an alpha source publication, not a formal GitHub Release. Earlier local packaging checks did not execute Windows commands. Current repository contents require their own runtime validation. Report results using the issue template and redact personal information. Script annotations do not imply additional testing.

## License
No open-source license has been selected. Public visibility alone does not grant an open-source license.
