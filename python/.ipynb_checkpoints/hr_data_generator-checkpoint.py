import numpy as np
from datetime import datetime, timedelta
import random
import os
import yaml
import logging
import pandas as pd
from faker import Faker

# -------------------------------------------------------------------
# Load config
# -------------------------------------------------------------------
CONFIG_PATH = os.path.join(os.path.dirname(__file__), "..", "config", "settings.yaml")

with open(CONFIG_PATH, "r") as f:
    config = yaml.safe_load(f)

RAW_DIR = config["raw_data_dir"]
EMPLOYEES_FILE = config["employees_file"]
EVENTS_FILE = config["events_file"]
N_EMPLOYEES = config["n_employees"]

# -------------------------------------------------------------------
# Logging (production-grade)
# -------------------------------------------------------------------
logging.basicConfig(
    level=getattr(logging, config["log_level"]),
    format="%(asctime)s [HR_DATA_GENERATOR] %(levelname)s - %(message)s"
)

fake = Faker()

os.makedirs(RAW_DIR, exist_ok=True)


# -------------------------------------------------------------------
# Generate Employees
# -------------------------------------------------------------------
def generate_employees(n_employees: int, as_of_date: datetime) -> pd.DataFrame:
    roles = [
        "Software Engineer", "Data Engineer", "HR Specialist", "Sales Manager",
        "Product Manager", "Finance Analyst", "Support Specialist"
    ]

    departments = {
        "Software Engineer": "Engineering",
        "Data Engineer": "Data",
        "HR Specialist": "HR",
        "Sales Manager": "Sales",
        "Product Manager": "Product",
        "Finance Analyst": "Finance",
        "Support Specialist": "Support"
    }

    countries = ["Canada", "USA", "UK", "Nigeria", "India", "Germany"]
    genders = ["Male", "Female", "Non-binary"]

    employees = []

    for i in range(n_employees):
        employee_id = f"E{1000 + i}"
        first_name = fake.first_name()
        last_name = fake.last_name()
        gender = random.choice(genders)
        birth_date = fake.date_between(start_date="-60y", end_date="-22y")

        hire_date = fake.date_between(
            start_date=datetime(as_of_date.year - 10, 1, 1),
            end_date=as_of_date
        )

        # 30% attrition
        if random.random() < 0.3:
            termination_date = hire_date + timedelta(days=random.randint(200, 2000))
            if termination_date > as_of_date.date():
                termination_date = None
        else:
            termination_date = None

        job_title = random.choice(roles)
        department = departments[job_title]
        country = random.choice(countries)
        city = fake.city()

        base_salary = {
            "Software Engineer": (80000, 130000),
            "Data Engineer": (85000, 135000),
            "HR Specialist": (50000, 80000),
            "Sales Manager": (60000, 110000),
            "Product Manager": (90000, 140000),
            "Finance Analyst": (55000, 90000),
            "Support Specialist": (40000, 70000)
        }[job_title]

        salary = random.randint(*base_salary)

        employees.append({
            "employee_id": employee_id,
            "first_name": first_name,
            "last_name": last_name,
            "gender": gender,
            "birth_date": birth_date,
            "hire_date": hire_date,
            "termination_date": termination_date,
            "country": country,
            "city": city,
            "job_title": job_title,
            "department": department,
            "manager_id": None,
            "salary": salary,
            "created_at": as_of_date,
            "updated_at": as_of_date
        })

    return pd.DataFrame(employees)


# -------------------------------------------------------------------
# Generate Employee Events
# -------------------------------------------------------------------
def generate_employee_events(employees: pd.DataFrame, as_of_date: datetime,
                             max_events_per_employee: int = 5) -> pd.DataFrame:

    event_types = ["promotion", "transfer", "salary_change", "termination"]

    roles = [
        "Software Engineer", "Data Engineer", "HR Specialist", "Sales Manager",
        "Product Manager", "Finance Analyst", "Support Specialist"
    ]

    departments = {
        "Software Engineer": "Engineering",
        "Data Engineer": "Data",
        "HR Specialist": "HR",
        "Sales Manager": "Sales",
        "Product Manager": "Product",
        "Finance Analyst": "Finance",
        "Support Specialist": "Support"
    }

    events = []
    event_id_counter = 1

    for _, row in employees.iterrows():
        n_events = random.randint(0, max_events_per_employee)
        hire_date = row["hire_date"]
        termination_date = row["termination_date"]

        for _ in range(n_events):
            event_type = random.choice(event_types)
            end_date = termination_date or as_of_date.date()
            event_date = fake.date_between(start_date=hire_date, end_date=end_date)

            new_job_title = None
            new_department = None
            new_salary = None

            if event_type in ["promotion", "transfer"]:
                new_job_title = random.choice(roles)
                new_department = departments[new_job_title]
                new_salary = int(row["salary"] * random.uniform(1.05, 1.3))

            elif event_type == "salary_change":
                new_salary = int(row["salary"] * random.uniform(0.95, 1.2))

            elif event_type == "termination":
                if termination_date:
                    event_date = termination_date

            events.append({
                "event_id": event_id_counter,
                "employee_id": row["employee_id"],
                "event_type": event_type,
                "event_date": event_date,
                "new_job_title": new_job_title,
                "new_department": new_department,
                "new_salary": new_salary,
                "created_at": as_of_date
            })

            event_id_counter += 1

    return pd.DataFrame(events)


# -------------------------------------------------------------------
# Write Raw Files (production-grade)
# -------------------------------------------------------------------
def write_raw_files(n_employees: int = 1000):
    as_of_date = datetime.now()

    logging.info("Generating employees...")
    employees_df = generate_employees(n_employees, as_of_date)

    logging.info("Generating events...")
    events_df = generate_employee_events(employees_df, as_of_date)

    employees_path = os.path.join(RAW_DIR, EMPLOYEES_FILE)
    events_path = os.path.join(RAW_DIR, EVENTS_FILE)

    employees_df.to_csv(employees_path, index=False)
    events_df.to_csv(events_path, index=False)

    logging.info(f"Raw employees written to: {employees_path}")
    logging.info(f"Raw events written to: {events_path}")


# -------------------------------------------------------------------
# Main
# -------------------------------------------------------------------
if __name__ == "__main__":
    write_raw_files()
