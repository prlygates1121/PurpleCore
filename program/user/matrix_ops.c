#ifdef X86
    #include <stdio.h>
#endif

// Define the size of the square matrices (N x N)
#define N 5

// --- Function Declarations ---

// Function to multiply two square matrices
void multiplyMatrices(int size, int A[size][size], int B[size][size], int C[size][size]);

// Function to get the cofactor matrix (submatrix)
void getCofactor(int mat_size, int mat[mat_size][mat_size], int temp[mat_size-1][mat_size-1], int p, int q);

// Recursive function to calculate the determinant of a matrix
int determinant(int size, int mat[size][size]);

// --- Main Function ---
int main() {
    // --- Define Square Matrices (NxN) ---
    // int matrixA[N][N] = {
    //     {1, 2, 3},
    //     {4, 5, 6},
    //     {7, 8, 9} // Note: This matrix is singular (determinant 0)
    //               // Let's use a non-singular one for a non-zero result
    // };

     int matrixA_nonsingular[N][N] = {
        {1, 0, 3, 4, 5},
        {0, 1, 2, 3, 4},
        {1, 2, 1, 0, 0},
        {2, 3, 4, 1, 0},
        {3, 4, 5, 6, 1} // This matrix is non-singular (determinant != 0)
    };


    int matrixB[N][N] = {
        {8, -1, 2, 0, 1},
        {3, 5, 0, 2, -1},
        {4, 0, 6, 1, 3},
        {2, 1, -3, 4, 0},
        {1, 2, 3, -1, 5} // This matrix is also non-singular
    };

    // Result Matrix C (NxN), initialized to all zeros
    int resultC[N][N] = {0};

    // --- Perform Matrix Multiplication ---
    // Using the non-singular matrix A for a potentially non-zero determinant result
    multiplyMatrices(N, matrixA_nonsingular, matrixB, resultC);

    // --- Calculate Determinant of the Result Matrix ---
    volatile int detResult = determinant(N, resultC);

#ifdef X86
    // --- Print Only the Determinant ---
    printf("Determinant of the resulting matrix (A * B): %d\n", detResult);
#endif

    return 0; // Indicate successful execution
}

// --- Function Definitions ---

// Function to multiply two square matrices A and B, store in C
void multiplyMatrices(int size, int A[size][size], int B[size][size], int C[size][size]) {
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            C[i][j] = 0; // Initialize element C[i][j]
            for (int k = 0; k < size; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
}

// Corrected function definition
void getCofactor(int mat_size, int mat[mat_size][mat_size], int temp[mat_size-1][mat_size-1], int p, int q) {
    int i = 0, j = 0;
    for (int row = 0; row < mat_size; row++) {
        for (int col = 0; col < mat_size; col++) {
            if (row != p && col != q) {
                temp[i][j++] = mat[row][col];
                // If a row of the temp matrix is full
                if (j == mat_size - 1) {
                    j = 0;
                    i++;
                }
            }
        }
    }
}

// Recursive function for finding determinant of matrix.
// size is current dimension of mat[][].
int determinant(int size, int mat[size][size]) {
    int D = 0; // Initialize result

    // Base case: if matrix contains single element
    if (size == 1)
        return mat[0][0];

    // Base case: if matrix is 2x2
    if (size == 2)
        return (mat[0][0] * mat[1][1]) - (mat[0][1] * mat[1][0]);


    // To store cofactors
    // Note: Using Variable Length Array (VLA) for temp.
    //       Requires C99 or later. If using older C, allocate dynamically.
    int temp[size - 1][size - 1];

    int sign = 1; // To store sign multiplier

    // Iterate for each element of first row
    for (int f = 0; f < size; f++) {
        // Getting Cofactor of mat[0][f]
        getCofactor(size, mat, temp, 0, f);
        D += sign * mat[0][f] * determinant(size - 1, temp);

        // terms are to be added with alternate sign
        sign = -sign;
    }

    return D;
}