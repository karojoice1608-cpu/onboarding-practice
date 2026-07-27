const display = document.getElementById("display");
const buttons = document.querySelectorAll("button");

let expression = "";
let errorState = false;
let resultShown = false;

buttons.forEach(button => {

    button.addEventListener("click", function () {

        const value = button.dataset.value;

        
        if (errorState) {
            expression = "";
            display.value = "";
            errorState = false;
        }

        if (resultShown) {

            if (!["+", "-", "*", "/", "="].includes(value)) {
                expression = "";
                display.value = "";
            }

            resultShown = false;
        }

        if (value === "C") {
            expression = "";
            display.value = "";
            resultShown = false;
            return;
        }

        if (value === "DEL") {
            expression = expression.slice(0, -1);
            display.value = expression;
            return;
        }

        if (value === "=") {
            calculate();
            return;
        }

     
        if (value === ".") {

            let lastNumber = expression.split(/[+\-*/]/).pop();

            if (lastNumber.includes(".")) {
                return;
            }
        }

     
        let currentNumber = expression.split(/[+\-*/]/).pop();

        if (!["+", "-", "*", "/", "."].includes(value)) {

            if (currentNumber.length >= 15) {
                display.value = "Error";
                expression = "";
                errorState = true;
                return;
            }
        }

        expression += value;
        display.value = expression;

    });

});

function calculate() {

    let numbers = expression.split(/[+\-*/]/);
    let operators = expression.match(/[+\-*/]/g);

    if (!operators) {
        return;
    }

    let result = Number(numbers[0]);

    for (let i = 0; i < operators.length; i++) {

        let num = Number(numbers[i + 1]);

        switch (operators[i]) {

            case "+":
                result += num;
                break;

            case "-":
                result -= num;
                break;

            case "*":
                result *= num;
                break;

            case "/":

                if (num === 0) {
                    display.value = "Cannot divide by 0";
                    expression = "";
                    errorState = true;
                    return;
                }

                result /= num;
                break;
        }
    }

    if (!Number.isFinite(result) || result.toString().length > 15) {
        display.value = "Error";
        expression = "";
        errorState = true;
        return;
    }

    expression = result.toString();
    display.value = expression;
    resultShown = true;
}