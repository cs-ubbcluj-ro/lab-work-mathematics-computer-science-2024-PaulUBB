# Function to parse the FA file and extract components
def parse_fa_file(filename):
    try:
        with open(filename, 'r') as file:
            content = file.read().strip()
            sections = content.split("##")

            if len(sections) != 4:
                raise ValueError("Input file does not have the correct format with 4 sections.")

            # Extract components
            states = set(sections[0].strip().splitlines())  # States
            alphabet = set(sections[1].strip().splitlines())  # Alphabet
            transitions = {}
            for line in sections[2].strip().splitlines():
                src, symbol, dest = line.split()
                if src not in transitions:
                    transitions[src] = {}
                transitions[src][symbol] = dest
            final_states = set(sections[3].strip().splitlines())  # Final States

            # Return components
            return states, alphabet, transitions, final_states
    except Exception as e:
        print(f"Error parsing FA file: {e}")
        return None

# Function to display the FA components
def display_fa(states, alphabet, transitions, final_states):
    print("Set of States:", states)
    print("Alphabet:", alphabet)
    print("Transitions:")
    for src in transitions:
        for symbol in transitions[src]:
            print(f"δ({src}, {symbol}) -> {transitions[src][symbol]}")
    print("Final States:", final_states)

# Function to validate a string based on the FA
def validate_string(input_string, start_state, transitions, final_states):
    current_state = start_state

    # Traverse the string character by character
    for char in input_string:
        if char not in transitions.get(current_state, {}):
            print(f"Invalid transition from state {current_state} on symbol {char}.")
            return False
        current_state = transitions[current_state][char]

    # Check if we ended in a final state
    if current_state in final_states:
        return True
    else:
        print("The string ended in a non-final state.")
        return False

if __name__ == "__main__":
    fa_file = "FA.in"  # File containing FA definition
    
    # Parse the FA file
    result = parse_fa_file(fa_file)
    if result is None:
        print("Failed to parse the FA file. Exiting.")
        exit(1)

    # Unpack the parsed components
    states, alphabet, transitions, final_states = result

    # Display FA components
    display_fa(states, alphabet, transitions, final_states)

    # Ask the user for a string to validate
    input_string = input("Enter a string to validate: ").strip()
    
    # Validate the string
    start_state = 'q0'  # Starting state
    if validate_string(input_string, start_state, transitions, final_states):
        print("The string is a valid lexical token.")
    else:
        print("The string is not a valid lexical token.")

