"""Run saved RTL through Vivado and fail clearly when a job fails."""
import argparse
from datetime import datetime
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import time


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--vivado", default="vivado", help="Vivado executable or launcher path")
    parser.add_argument("--dry-run", action="store_true", help="List jobs without executing Vivado")
    args = parser.parse_args(argv)
    root = Path(__file__).resolve().parent
    sources = sorted((root / "v_src").glob("*.v"))
    if not sources:
        print("No RTL files found under hardware/v_src.", file=sys.stderr)
        return 1
    if args.dry_run:
        for source in sources:
            print(source.name)
        print(f"{len(sources)} jobs; no Vivado processes started.")
        return 0
    executable = shutil.which(args.vivado)
    if executable is None:
        print("Vivado not found. Set PATH or supply --vivado.", file=sys.stderr)
        return 1
    reports_root = root / "reports"
    reports_root.mkdir(exist_ok=True)
    run_dir = Path(tempfile.mkdtemp(prefix=datetime.now().strftime("%Y%m%d_%H%M%S_"), dir=reports_root))
    started = time.monotonic()
    failures = []
    for source in sources:
        module = source.stem
        work = run_dir / module
        work.mkdir()
        command = [executable, "-mode", "batch", "-notrace", "-source",
                   str(root / "run_vivado.tcl"), "-tclargs", module,
                   str(source), str(work)]
        print(f"Processing {module} ...", flush=True)
        try:
            with (work / "console.txt").open("w", encoding="utf-8") as log:
                result = subprocess.run(command, cwd=work, stdout=log,
                                        stderr=subprocess.STDOUT, check=False)
            expected = [work / f"{module}_{kind}.txt" for kind in ("util", "timing", "power")]
            if result.returncode != 0 or not all(p.is_file() and p.stat().st_size > 0 for p in expected):
                failures.append(module)
                print(f"FAILED: {module} (exit {result.returncode}); inspect {work / 'console.txt'}")
            else:
                print(f"Completed: {module}")
        except OSError as exc:
            failures.append(module)
            print(f"FAILED: {module}: {exc}", file=sys.stderr)
    print(f"Completed {len(sources) - len(failures)}/{len(sources)} jobs in {(time.monotonic()-started)/60:.2f} minutes.")
    print(f"Reports and console logs: {run_dir}")
    if failures:
        print("Failed modules: " + ", ".join(failures), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
