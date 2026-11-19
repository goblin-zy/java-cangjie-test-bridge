# 📚 Smart Library: Software Testing Project

A software testing and quality assurance project built around **Smart Library**, a Java system for managing library circulation: members borrow and return items, and the system applies borrowing rules, overdue fines and reminders. The project covers the full testing process, from static analysis to unit, integration and system tests, with **445 automated tests** written in **JUnit 5** and **Mockito**.

Built for the Software Testing & Quality Assurance course.

## The system under test

The Smart Library code (`src/main/java/smartlibrary`) is organized in layers:

- **Model:** members, library items, borrow records, and three membership types with different limits (Student: 3 loans for 14 days, Staff: 5 for 30 days, Guest: 1 for 7 days)
- **Policies:** the borrowing rule (active member, under the loan limit, no overdue items) and the fine rule (1 per overdue day for up to 5 days, 2 per day when more than 5 days late, capped at 100)
- **Circulation service:** borrowing, returning, fines and discounts, renewals, member status checks and due-date reminders
- **Storage:** in-memory storage for members, items and borrow records
- **Facade and notifications:** the borrow and return flows, and a stub alert service

## Testing work

**Part 1 – Static testing:** the code was analyzed with static analysis tools (SpotBugs and SonarQube) and reviewed for documentation style and clarity.

**Part 2 – Testing analysis (169 tests):** each team member analyzed different methods of the circulation service using:
- Boundary value testing
- Equivalence class / decision table testing
- Code coverage: statement, branch, condition and MC/DC coverage

**Part 3 – Unit, integration and system testing (276 tests):**
- **Unit tests (200):** every class tested in isolation, with Mockito mocks for its dependencies
- **Bottom-up integration tests (60):** combining layers step by step, from storage, to policies, to the circulation service, to the facade
- **System tests (16):** full borrow and return scenarios through the whole system

Each Part 3 test is documented with its description, reason, expected and actual result, test type and the responsible team member.

## Project structure

- `src/main/java/smartlibrary/`: the Smart Library system
- `src/test/java/smartlibrary/`
  - `Part1_Testing/`: static testing report
  - `Part2_Testing/`: one folder per team member, with their tests and analysis report
  - `Part3_Testing/`: `Unit/`, `BottomUp_Integration/` and `System/` tests, each with its documentation
  - `Final_Documentation.pdf` and `Final_Presentation.pdf`: the final project report and presentation
- `pom.xml`: Maven build (Java 17, JUnit 5, Mockito)

Each part and each folder also has its own README with more details.

## How to run the tests

You need **Java 17 or newer** (check with `java -version`).

**Terminal:** from the project folder, run:

```bash
./mvnw test          # Mac / Linux
mvnw.cmd test        # Windows
```

The first run downloads Maven and the test libraries, so it needs an internet connection. At the end you should see `Tests run: 445, Failures: 0, Errors: 0`.

**IntelliJ IDEA:** open the project folder (it loads as a Maven project), then right-click the `src/test/java` folder and choose **Run 'All Tests'**. You can also run any single test class or part the same way.

## Team

Viola Zeneli, Sidrit Rrustemi, Megi Almadhi and Arsildo Veliu
