
#!/usr/bin/env python
from __future__ import print_function
import argparse
import subprocess

def run_germline(args):
    # cmd = f"mkdir -p {args.work_directory} && cd {args.work_directory}"
    # cmd += f"{args.strelka_path}/bin/configureStrelkaGermlineWorkflow.py "
    # for b in args.normal_bam:
    #     cmd += f"--bam {b} "
    # cmd += f"--referenceFasta {args.reference} "
    # cmd += f"--runDir {args.work_directory} "
    # cmd += f" && cd {args.work_directory} && ./runWorkflow.py -m local -j {args.parallel_threads}"


    cmd = "mkdir -p " + args.work_directory + " && cd " + args.work_directory + " &&  " 
    cmd += args.strelka_path + "/bin/configureStrelkaGermlineWorkflow.py "
    for b in args.normal_bam:
        cmd += "--bam " + b + " " 
    cmd += "--referenceFasta " + args.reference + " "
    cmd += "--runDir " + args.work_directory + " "
    cmd += " && cd " + args.work_directory + " && ./runWorkflow.py -m local -j " + str(args.parallel_threads)
    print(cmd)
    subprocess.call(cmd, shell=True)

    return 0


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-N", "--normal-bam",
     type=str, action="append", help="A germline BAM or a normal BAM (if a tumor bam is provided.")
    parser.add_argument("-T", "--tumor-bam",
     type=str, action="append", help="A tumor BAM file. Triggers somatic workflow.")
    parser.add_argument("-p", "--parallel-threads",
     type=int, default=16)
    parser.add_argument("-r", "--reference",
     type=str, required=True)
    parser.add_argument("-w", "--work-directory",
     type=str, default="strelka_work",
     help="Path to strelka work dir. WARNING: will be overwritten if it exists.")
    parser.add_argument("-b", "--bed-file",
     type=str, help="A bed file of regions to be called.")
    parser.add_argument("-S", "--strelka-path", type=str, help="Path to strelka installation.", default="/opt")

    return parser.parse_args(), parser

if __name__ == "__main__":

    args, parser = parse_args()

    if args.normal_bam is None and args.tumor_bam is None:
        parser.print_help()
        exit(1)
    elif args.normal_bam is not None and args.tumor_bam is None:
        run_germline(args)
