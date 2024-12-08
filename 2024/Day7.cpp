#include <iostream>
#include <fstream>
#include <string>
#include <vector>

#include <boost/algorithm/string.hpp>

bool is_equation_fixable(std::vector<long>);

bool is_equation_fixable_helper(long,
                                long,
                                std::vector<long>::const_iterator)

int main(int argc, char *argv[])
{
    /* SETUP! */

    // long long test = 116094961956019;
    // std::cout << test << std::endl;
    // return 0;

    std::ifstream inputFile(argv[1]);
    std::string inputLine;

    std::vector<std::vector<long>> equations;

    // Read and parse our puzzle input.

    while (getline(inputFile, inputLine))
    {
        // Index 0 contains the needed result, and indexes 1 and on contain the
        // operands that ought to be used to get said result in the equation.

        std::vector<std::string> tokens;
        std::vector<long> eq;
        boost::split(tokens, inputLine, boost::is_any_of(" "));

        for (auto it = tokens.cbegin(); it != tokens.cend(); it++)
        {
            long value = std::stol(*it);
            eq.push_back(value);
        }
        equations.push_back(eq);
    }

    long long result1 = 0;

    for (auto it = equations.cbegin(); it != equations.cend(); it++)
    {
        // Check each equation, and if it's possible to make it true, then add
        // its result to the puzzle's result.
        if (is_equation_fixable(*it))
            result1 += (*it)[0];
    }

    std::cout << "PART ONE: " << result1 << std::endl;
    return 0;
}

bool is_equation_fixable(std::vector<long> equation)
{
    // If we only have two operands, we can just test both options '+' and '*',
    // and check the result in a reasonable amount of time.

    if (equation.size() == 3)
    {
        return (equation[1] + equation[2]) == equation[0]
            || (equation[1] * equation[2]) == equation[0];
    }

    // For our recursive helper, it's best to have a list of just the operands.
    // Also, let me be funny and use iterators here instead of indexes :)

    std::vector<long> ops = std::vector<long>(equation.cbegin() + 1,
                                              equation.cend());

    long eq_result = *(equation.cbegin());
    std::vector<long>::const_iterator ops_it = ops.cbegin();

    return is_equation_fixable_helper(eq_result, *ops_it, ++ops_it);
}

bool is_equation_fixable_helper(
    long expected,
    long result,
    std::vector<long>::const_iterator ops_it)
{
    return true;
}
