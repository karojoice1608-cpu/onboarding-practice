/* DUPLICATE ARRAY*/
function duplicateArray(arr){
    let result=[];
    for(let i=0; i<arr.length; i++){
        if(!result.includes(arr[i])){
            result.push(arr[i]);
    }
}
return result;
}
let num=[1,2,3,4,4,5,6,6,1,3,7,8,9];
let output=duplicateArray(num);
console.log(output);