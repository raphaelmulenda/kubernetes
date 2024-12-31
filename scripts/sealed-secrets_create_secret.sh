# Initialize variables
filename=""
namespace=""
secret_name=""
output=""

# Function to display usage
usage() {
	echo "Usage: $0 -f <filename> -n <namespace> -s <secret-name> -o <output>"
	echo "  -f: Specify the filename of your Secret resource with"
	echo "  -o: Specify the output file"
	exit 1
}

# Parse command line options
while getopts ":f:o:" opt; do
	case $opt in
	f) filename="$OPTARG" ;;
	o) output="$OPTARG" ;;
	\?)
		echo "Invalid option -$OPTARG" >&2
		usage
		;;
	:)
		echo "Option -$OPTARG requires an argument" >&2
		usage
		;;
	esac
done

# Check if all required options are provided
if [ -z "$filename" ] || [ -z "$output" ]; then
	echo "Error: All options (-f, -o) are required"
	usage
fi

# Check if the file exists
if [ ! -f "$filename" ]; then
	echo "Error: File '$filename' not found"
	exit 1
fi

read -p "Are you sure? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	SEALED_SECRET=$(kubeseal --cert ~/.kube/kubeseal_local_cert.pem -w $output -f <(cat $filename))
	echo -e "\n\n\n"
	echo "Generated Sealed Secret"
	echo $SEALED_SECRET
fi

echo -e "\n\n\n"
echo -e "Sealed Secret saved as $output"
echo -e "\n\n\n"

read -p "Deploy it?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo -e "\n\n\n\n"
	echo "Deploying Sealed Secret"
	kubectl apply -f $output
fi
