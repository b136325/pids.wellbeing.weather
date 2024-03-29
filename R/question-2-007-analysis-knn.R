library(class)
library(dplyr)
library(magrittr)
####################################################
#                                                  #
# EXPORTED FUNCTION                                #
#                                                  #
####################################################
#' question_2_007_analysis_knn
#' @export
question_2_007_analysis_knn <- function(
  data = question_2_006_prep_split(),
  k_value = 3
) {
  perform_knn(
    data$training,
    data$test,
    k_value
  )
}
####################################################
#                                                  #
# NON EXPORTED FUNCTIONS (A-Z)                     #
#                                                  #
####################################################
accuracy <- function(confusion_matrix) {
  sum(
    diag(confusion_matrix) / (sum(rowSums(confusion_matrix)))
  ) * 100
}

perform_knn <- function(
  data_frame_training,
  data_frame_test,
  k_value
) {
  knn_test_data <- rescale_knn_data_frame(
    select_knn_features(
      data_frame_test
    )
  )
  knn_training_data <- rescale_knn_data_frame(
    select_knn_features(
      data_frame_training
    )
  )
  knn_test_labels <- select_knn_labels(
    data_frame_test
  )
  knn_training_labels <- select_knn_labels(
    data_frame_training
  )
  model <- knn(
    knn_training_data,
    knn_test_data,
    knn_training_labels,
    k = k_value
  )
  confusion_matrix <- table(
    model,
    knn_test_labels
  )
  output <- list()
  output$accuracy <- accuracy(confusion_matrix)
  output$confusion_matrix <- confusion_matrix
  output$model <- model
  output
}

rescale_knn_data_frame <- function(data_frame) {
  data_frame %>%
    select(
      hours_sun,
      latitude,
      longitude,
      rain_mm,
      temp_max_degrees_c,
      temp_min_degrees_c,
    ) %>%
    mutate_each(rescale)
}

select_knn_features <- function(data_frame) {
  data_frame %>%
    select(
      hours_sun,
      latitude,
      longitude,
      rain_mm,
      temp_max_degrees_c,
      temp_min_degrees_c
    )
}

select_knn_labels <- function(data_frame) {
  as.integer(
    data_frame$latitude_category
  )
}
