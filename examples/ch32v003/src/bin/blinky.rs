#![no_std]
#![no_main]

use ch32_hal as hal;
use hal::delay::Delay;
use hal::gpio::{Level, Output};
use panic_halt as _;

#[qingke_rt::entry]
fn main() -> ! {
    hal::debug::SDIPrint::enable();

    let mut config = hal::Config::default();
    config.rcc = hal::rcc::Config::SYSCLK_FREQ_48MHZ_HSI; // Internal oscillator

    let p = hal::init(config);
    let mut led = Output::new(p.PC4, Level::Low, Default::default());

    let mut delay = Delay;
    loop {
        led.toggle();
        delay.delay_ms(1000);
        hal::println!("toggle!");
        let val = hal::pac::SYSTICK.cnt().read();
        hal::println!("systick: {}", val);
    }
}
