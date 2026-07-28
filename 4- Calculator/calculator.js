const display = document.getElementById("display");
const buttons = document.querySelectorAll("button");

let expression = "";
let errorState = false;
let resultShown = false;

buttons.forEach(button => {

    button.addEventListener("click", function () {

        handleInput(button.dataset.value);

    });

});


function handleInput(value) {

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

    if (
        expression === "" &&
        (value === "*" || value === "/" || value === ".")
    ) {
        return;
    }

   
    const lastChar = expression.slice(-1);

    if (
        ["+", "-", "*", "/"].includes(lastChar) &&
        ["+", "-", "*", "/"].includes(value)
    ) {
        return;
    }

    
    if (value === ".") {

        let lastNumber = expression.split(/[+\-*/]/).pop();

        if (lastNumber.includes(".")) {
            return;
        }

        if (lastNumber === "") {
            expression += "0";
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
}

function calculate() {

    if (expression === "") return;

    
    if (/[+\-*/]$/.test(expression)) {
        display.value = "Error";
        expression = "";
        errorState = true;
        return;
    }

    try {

    
        let tokens = expression.match(/\d+(\.\d+)?|[+\-*/]/g);

     
        let stack = [];
        stack.push(Number(tokens[0]));

        for (let i = 1; i < tokens.length; i += 2) {

            let operator = tokens[i];
            let number = Number(tokens[i + 1]);

            if (operator === "*") {

                stack.push(stack.pop() * number);

            } else if (operator === "/") {

                if (number === 0) {
                    display.value = "Cannot divide by 0";
                    expression = "";
                    errorState = true;
                    return;
                }

                stack.push(stack.pop() / number);

            } else {

                stack.push(operator);
                stack.push(number);

            }

        }

      
        let result = stack[0];

        for (let i = 1; i < stack.length; i += 2) {

            let operator = stack[i];
            let number = stack[i + 1];

            if (operator === "+") {
                result += number;
            } else {
                result -= number;
            }

        }

        if (
            !Number.isFinite(result) ||
            result.toString().length > 15
        ) {
            display.value = "Error";
            expression = "";
            errorState = true;
            return;
        }

        expression = result.toString();
        display.value = expression;
        resultShown = true;

    } catch {

        display.value = "Error";
        expression = "";
        errorState = true;

    }

}


document.addEventListener("keydown", function (event) {

    const key = event.key;

    if ((key >= "0" && key <= "9") ||
        ["+", "-", "*", "/", "."].includes(key)) {

        handleInput(key);

    }
    else if (key === "Enter" || key === "=") {

        event.preventDefault();
        handleInput("=");

    }
    else if (key === "Backspace") {

        handleInput("DEL");

    }
    else if (key === "Escape") {

        handleInput("C");

    }

});