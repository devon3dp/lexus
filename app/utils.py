from mnemonic import Mnemonic

def generate_seed_ui():
    mnemo = Mnemonic("english")
    seed = mnemo.generate(strength=256)
    print(f"Generated Seed: {seed}")
