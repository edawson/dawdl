import sys
import argparse

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input-vcf", dest="input_vcf", help="An input VCF to filter", type=str, required=True)
    parser.add_argument("-o", "--output-vcf", dest="output_vcf", help="A path to write the output VCF to.", type=str, required=True)
    parser.add_argument("--child", dest="child", type=str, help="A sample name for the child sample.", required=True)
    parser.add_argument("--mother", dest="mother", type=str, help="A sample name for the mother sample.", required=True)
    parser.add_argument("--father", dest="father", type=str, help="A sample name for the father sample.", required=True)
    return parser.parse_args()
if __name__ == "__main__":

    args = parse_args()
    child_index = 0
    mother_index = 1
    father_index = 2
    valid_child_genotypes = set(["1|0", "0|1", "0/1", "1/0"])
    valid_parent_genotypes = set(["0/0", "0|0"])
    with open(args.input_vcf, "r") as ifi, \
        open(args.output_vcf, "w") as ofi:
        for line in ifi:
            line = line.strip()
            if line.startswith("#"):
                ofi.write(line + "\n")
                if line.startswith("#CHROM"):
                    cols = line.split("\t")
                    samples = cols[-3:]
                    mother_index = samples.index(args.mother)
                    child_index = samples.index(args.child)
                    father_index = samples.index(args.father)
            else:
                splits = line.split("\t")
                child_samp_geno = splits[9 + child_index].split(":")[0]
                mother_samp_geno = splits[9 + mother_index].split(":")[0]
                father_samp_geno = splits[9 + father_index].split(":")[0]
                if father_samp_geno in valid_parent_genotypes and \
                mother_samp_geno in valid_parent_genotypes and \
                child_samp_geno in valid_child_genotypes:
                    ofi.write(line + "\n")
                


            
