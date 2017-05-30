int factorial(int n){
    int res;
    int n1;
    if (n <= 1){
        res = 1;
    }else{
        n1 = n-1;
        res = factorial(n1);
        res = res * n;
    }
    return res;
}

int main(){
    int a;
    a = factorial(4);
    printf(a);
}
