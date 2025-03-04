Hello there. AutoBooster is a simple tool (theat can be installed as as Systemd-service) designed to 
automatically, in dependency of AVG load, enable and disable ["turbo" mode](https://www.intel.com/content/www/us/en/gaming/resources/turbo-boost.html) for Intel CPUs. 

AutoBooster is developed and designed only for Linux-based OSs. It is inspired by the [Auto CpuFreq](https://github.com/AdnanHodzic/auto-cpufreq), [BoostChanger](https://github.com/nbebaw/boostchanger) and
[Boost Manager](https://github.com/kubadlo/intel-turboproject) projects but aims to provide a simpler (because of KIS), and more portable experience.

## Features

- Automatic performance tuning according to predefined or configured AVG amount.
- Easy to configure, it's just a shell script + INI-file
- Lightweight and efficient
- Compatible with various Linux systems

## Manual launch

To install AutoBooster, clone the repository and run the installation script:

```bash
git clone https://github.com/yourusername/anmcarrow.autobooster.git
cd anmcarrow.autobooster
sudo ./autobooster.sh
```

## Installation as a Systemd-service

To install AutoBooster, clone the repository and run the installation script:

```bash
git clone https://github.com/yourusername/anmcarrow.autobooster.git
cd anmcarrow.autobooster
sudo ./install.sh
```

## Usage as a service

After installation, you can start AutoBooster with the following command:

```bash
sudo systemctl start autobooster 
```

To stop the script, use:

```bash
sudo systemctl stop autobooster
```

## Configuration

Configuration options can be found in the `autobooster.ini` (or `/etc/autobooster.ini`, in case of installation as a service) file. 
You can edit this file to customize the behavior of AutoBooster according to your needs.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes.

## License

This project is licensed under the [MIT License](https://opensource.org/license/mit).

## Contact

For any questions or issues, please open an issue on the GitHub repository.
