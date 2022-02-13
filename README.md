# Politecnico di Milano - Progetto Reti Logiche 2021-2022

### How to install

First clone this repo, then:

```bash
pip3 install -r requirements.txt
```

or

```bash
pip install -r requirements.txt
```

### How to generate tests

```txt
Usage: generator.py [OPTIONS]

Options:
  --size INTEGER   Number of tests to generate  [default: 100]
  --limit INTEGER  Maximum input stream size  [default: 255]
  --help           Show this message and exit.
```

To generate tests run:

```bash
python3 generator.py
```

or

```bash
python generator.py
```

Example:

```sh
python generator.py --size 1000
```

#### Output

1. `test_values.txt`: human readable file containing the generated tests
2. `ram_content.txt`: file used by the Vivado testbench. It contains both the values loaded in RAM before testing your circuit, and the values that it checks after your circuit has finished processing.

### How to use in Vivado

1. Import `gen_testbench_no_reset.vhd` file in Vivado
2. Update the file with the correct file paths for `ram_content.txt`, `non_passati.txt` and `passati.txt`
3. Run the simulation using `gen_testbench_no_reset.vhd` as testbench
4. After the simulation ends, check `non_passati.txt` and `passati.txt` for the results

### Credits

Based on work of RL-generator-2020-21 by [Davide Merli](https://github.com/davidemerli/RL-generator-2020-2021)

Pretty print function by [Daniele Locatelli](https://github.com/locadani)

Importing RAM from outside feature by [Davide Mornatta](https://github.com/davidemornatta)

Original testbench code by [Mark Zampedroni](https://github.com/Mark-Zampedroni) [here](https://github.com/Mark-Zampedroni/multi-TB-progetto-Reti-PoliMi)
