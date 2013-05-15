# encoding: utf-8

class AddMayElectionDataPoints < ActiveRecord::Migration
  GROUP_NAME = "election-may2013"
  NOTES = "Number only (no % symbol)"

  def up
    DataPoint.create([

      # MAYOR
      {
        group_name: GROUP_NAME,
        title: "Mayor: Percent Reporting",
        data_key: "mayor:percent_reporting",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Wendy J. Greuel",
        data_key: "mayor:percent_GREUEL",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Eric Garcetti",
        data_key: "mayor:percent_GARCETTI",
        notes: NOTES

      },



      # CITY ATTORNEY
      {
        group_name: GROUP_NAME,
        title: "City Attorney: Percent Reporting",
        data_key: "attorney:percent_reporting",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Mike Feuer",
        data_key: "attorney:percent_FEUER",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Carmen \"Nuch\" Trutanich",
        data_key: "attorney:percent_TRUTANICH",
        notes: NOTES

      },



      # CONTROLLER
      {
        group_name: GROUP_NAME,
        title: "City Controller: Percent Reporting",
        data_key: "controller:percent_reporting",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Ron Galperin",
        data_key: "controller:percent_GALPERIN",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Dennis P. Zine",
        data_key: "controller:percent_ZINE",
        notes: NOTES

      },



      # PROPOSITION C
      {
        group_name: GROUP_NAME,
        title: "Prop. C (Campaign Spending): Percent Reporting",
        data_key: "prop_c:percent_reporting",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Yes",
        data_key: "prop_c:percent_YES",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "No",
        data_key: "prop_c:percent_NO",
        notes: NOTES

      },



      # PROPOSITION D
      {
        group_name: GROUP_NAME,
        title: "Prop. D (Medical Marijuana): Percent Reporting",
        data_key: "prop_d:percent_reporting",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Yes",
        data_key: "prop_d:percent_YES",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "No",
        data_key: "prop_d:percent_NO",
        notes: NOTES

      },



      # ORDINANCE E
      {
        group_name: GROUP_NAME,
        title: "Ord. E (Medical Marijuana): Percent Reporting",
        data_key: "ord_e:percent_reporting",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Yes",
        data_key: "ord_e:percent_YES",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "No",
        data_key: "ord_e:percent_NO",
        notes: NOTES

      },



      # ORDINANCE F
      {
        group_name: GROUP_NAME,
        title: "Ord. F (Medical Marijuana): Percent Reporting",
        data_key: "ord_f:percent_reporting",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Yes",
        data_key: "ord_f:percent_YES",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "No",
        data_key: "ord_f:percent_NO",
        notes: NOTES

      },



      # LA CITY COUNCIL
      # COUNCIL D1
      {
        group_name: GROUP_NAME,
        title: "City Council CD1: Percent Reporting",
        data_key: "council:cd1:percent_reporting",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Gil Cedillo",
        data_key: "council:cd1:percent_CEDILLO",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "José Gardea",
        data_key: "council:cd1:percent_GARDEA",
        notes: NOTES

      },



      # COUNCIL D6
      {
        group_name: GROUP_NAME,
        title: "City Council CD6: Percent Reporting",
        data_key: "council:cd6:percent_reporting",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Walter Alexander Escobar",
        data_key: "council:cd6:percent_ESCOBAR",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "J. Roy Garcia",
        data_key: "council:cd6:percent_GARCIA",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Nury Martinez",
        data_key: "council:cd6:percent_MARTINEZ",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Cindy Montanez",
        data_key: "council:cd6:percent_MONTANEZ",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Richard Valdez",
        data_key: "council:cd6:percent_VALDEZ",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Derek Waleko",
        data_key: "council:cd6:percent_WALEKO",
        notes: NOTES

      },



      # COUNCIL D9
      {
        group_name: GROUP_NAME,
        title: "City Council CD9: Percent Reporting",
        data_key: "council:cd9:percent_reporting",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Ana Cubas",
        data_key: "council:cd9:percent_CUBAS",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Curren D. Price, Jr.",
        data_key: "council:cd9:percent_PRICE",
        notes: NOTES

      },



      # COUNCIL D13
      {
        group_name: GROUP_NAME,
        title: "City Council CD13: Percent Reporting",
        data_key: "council:cd13:percent_reporting",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "John J. Choi",
        data_key: "council:cd13:percent_CHOI",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Mitch O’Farrell",
        data_key: "council:cd13:percent_OFARRELL",
        notes: NOTES

      },



      # LOS ANGELES UNIFIED SCHOOL DISTRICT D6
      {
        group_name: GROUP_NAME,
        title: "LAUSD D6: Percent Reporting",
        data_key: "lausd:d6:percent_reporting",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Monica Ratliff",
        data_key: "lausd:d6:percent_RATLIFF",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Antonio Sanchez",
        data_key: "lausd:d6:percent_SANCHEZ",
        notes: NOTES

      },



      # LACCD BOARD OFFICE 6
      {
        group_name: GROUP_NAME,
        title: "LACCD Board O6: Percent Reporting",
        data_key: "laccd:o6:percent_reporting",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "Nancy Pearlman",
        data_key: "laccd:o6:percent_PEARLMAN",
        notes: NOTES

      },{
        group_name: GROUP_NAME,
        title: "David Vela",
        data_key: "laccd:o6:percent_VELA",
        notes: NOTES

      }

    ])
  end
  
  def down
    DataPoints.where(group_name: GROUP_NAME).destroy_all
  end
end
