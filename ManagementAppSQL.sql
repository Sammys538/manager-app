-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `ManagementDB` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ManagementDB` DEFAULT CHARACTER SET utf8 ;
USE `ManagementDB` ;

-- -----------------------------------------------------
-- Table `Users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Users` ;

CREATE TABLE IF NOT EXISTS `Users` (
  `id_users` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id_users`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_users_UNIQUE` ON `Users` (`id_users` ASC) VISIBLE;

CREATE UNIQUE INDEX `user_email_UNIQUE` ON `Users` (`email` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Transactions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Transactions` ;

CREATE TABLE IF NOT EXISTS `Transactions` (
  `id_transaction` INT NOT NULL AUTO_INCREMENT,
  `transaction_type` VARCHAR(45) NOT NULL,
  `category` VARCHAR(255) NOT NULL,
  `transaction_desc` VARCHAR(255) NULL,
  `transaction_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `transaction_amount` DECIMAL(10,2) NOT NULL,
  `admin_id` INT NOT NULL,
  PRIMARY KEY (`id_transaction`),
  CONSTRAINT `fk_admin_id_Transaction_Users`
    FOREIGN KEY (`admin_id`)
    REFERENCES `Users` (`id_users`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `idTransactions_UNIQUE` ON `Transactions` (`id_transaction` ASC) VISIBLE;

CREATE INDEX `fk_admin_id_Transaction_Users_idx` ON `Transactions` (`admin_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Offerings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Offerings` ;

CREATE TABLE IF NOT EXISTS `Offerings` (
  `idOfferings` INT NOT NULL auto_increment,
  `member_name` VARCHAR(100) NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `admin_id` INT NOT NULL,
  `offering_date` DATE NULL,
  PRIMARY KEY (`idOfferings`),
  CONSTRAINT `fk_admin_id`
    FOREIGN KEY (`admin_id`)
    REFERENCES `Users` (`id_users`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `idOfferings_UNIQUE` ON `Offerings` (`idOfferings` ASC) VISIBLE;

CREATE INDEX `fk_admin_id_idx` ON `Offerings` (`admin_id` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
