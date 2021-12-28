# Politecnico di Milano - Progetto Reti Logiche 2021-2022

## Test Generator

written in python3

### How to install

To install dependencies

```bash
pip3 install -r requirements.txt 
```

or

```bash
pip install -r requirements.txt 
```

depending on system installation

### How to generate tests

```bash
python3 generator.py
```

or

```bash
python generator.py
```

depending on system installation

```txt
Usage: generator.py [OPTIONS]

Options:
  --size INTEGER   Number of tests to generate  [default: 100]
  --limit INTEGER  Maximum input stream lenght size  [default: 128]
  --help           Show this message and exit.
```

```test_values.txt``` will contain all details about every single generated test, for debugging.
```ram_content.txt``` is the file that will be read by Vivado to load the ram values

Example:

```sh
python generator.py --size 1000 --limit 16
```

### How to import in Vivado

You can directly import the ```gen_testbench_reset.vhd``` (or ```gen_testbench_no_reset.vhd```) file as source in Vivado, then modify this file to match the folder containing the generated ram files. Instruction on how to modify it are included in the .vhd file itself.


### Credits
Based on work of RL-generator-2020-21 by [Davide Merli](https://github.com/davidemerli/RL-generator-2020-2021)

Pretty print function by [Daniele Locatelli](https://github.com/locadani)

Importing RAM from outside feature by [Davide Mornatta](https://github.com/davidemornatta)

Original testbench code by [Mark Zampedroni](https://github.com/Mark-Zampedroni) [here](https://github.com/Mark-Zampedroni/multi-TB-progetto-Reti-PoliMi)
