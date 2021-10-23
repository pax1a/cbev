#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  baseLineGlobal <- c()
  customerTotal <- c()
  
  customerPlot <- function(populationtStartInput, populationGrowthInput, customerStartInput, brandInput, employerInput, technologyInput) {
    populationtStart <- populationtStartInput
    populationGrowth <- populationGrowthInput
    customerStart <- customerStartInput
    
    population <- round(populationtStart * (1 + populationGrowth) ^ (0:30), digits = 0)
    populationDelta <- c(populationtStart, (population[2:31] - population[0:30])[1:29])
    
    ### Baseline calculation, all Metrics equal to 1
    
    acquiShape <- 1 * (1 + 1) / 2
    churnShape1 <- (1 * 1 * 1) / 3 * 10
    
    acqui <- pweibull(0:30, shape = acquiShape, scale = 20)
    churn <- pbeta((0:30)/30, shape1 = churnShape1, shape2 = 20)
    
    acquiDelta <- acqui[2:31] - acqui[0:30]
    churnDelta <- churn[2:31] - churn[0:30]
    
    acquiMatrix <- matrix(0, nrow = 30, ncol = 30)
    
    for(i in 1:30) {
      acquiMatrix[i,i:30] <- round(populationDelta[i] * acquiDelta[1:(31 - i)], digits = 0)
    }
    acquiYear <- colSums(acquiMatrix)
    
    churnMatrix <- matrix(0, nrow = 30, ncol = 30)
    
    
    
    existingCustomer <- round(- (churn[2:31] * customerStart) + customerStart, digits = 0)
    
    for(i in 2:30) {
      churnMatrix[i,i:30] <- round(- (acquiYear[i-1] * churn[1:(31 - i)]) + acquiYear[i-1], digits = 0)
    }
    
    newCustomerAfterChurn <- colSums(churnMatrix)
    
    baseline <- c(customerStart * c(0.7, 0.8, 0.85, 0.9, 0.95), rep(0, 31)) +
      c(0,0,0,0,0,customerStart,existingCustomer) +
      c(0,0,0,0,0,0,acquiYear) +
      c(0,0,0,0,0,0,newCustomerAfterChurn)
    
    ### END of Baseline calculation
    
    
    acquiShape <- brandInput * (employerInput + technologyInput) / 2
    churnShape1 <- (brandInput * employerInput * technologyInput) / 3 * 10
    
    acqui <- pweibull(0:30, shape = acquiShape, scale = 20)
    churn <- pbeta((0:30)/30, shape1 = churnShape1, shape2 = 20)
    
    acquiDelta <- acqui[2:31] - acqui[0:30]
    churnDelta <- churn[2:31] - churn[0:30]
    
    acquiMatrix <- matrix(0, nrow = 30, ncol = 30)
    
    for(i in 1:30) {
      acquiMatrix[i,i:30] <- round(populationDelta[i] * acquiDelta[1:(31 - i)], digits = 0)
    }
    acquiYear <- colSums(acquiMatrix)
    
    churnMatrix <- matrix(0, nrow = 30, ncol = 30)
    
    
    
    existingCustomer <- round(- (churn[2:31] * customerStart) + customerStart, digits = 0)
    
    for(i in 2:30) {
      churnMatrix[i,i:30] <- round(- (acquiYear[i-1] * churn[1:(31 - i)]) + acquiYear[i-1], digits = 0)
    }
    
    newCustomerAfterChurn <- colSums(churnMatrix)
    
    customerTotal <<- c(customerStart * c(0.7, 0.8, 0.85, 0.9, 0.95), customerStart, existingCustomer + acquiYear + newCustomerAfterChurn)
    
    bar <- barplot(
      names.arg = c("-5","","","","","0","","","","","5","","","","","10","","","","","15","","","","","20","","","","","25","","","","","30"),
      ylim=c(0, round(max(existingCustomer + acquiYear + newCustomerAfterChurn) * 1.4, digits = -2)),
      rbind(
        c(customerStart * c(0.7, 0.8, 0.85, 0.9, 0.95), rep(0, 31)),
        c(0,0,0,0,0,customerStart,existingCustomer),
        c(0,0,0,0,0,0,acquiYear),
        c(0,0,0,0,0,0,newCustomerAfterChurn)
      ),
      col=c("#dedede","#d93954","#ffb600","#eb8c00"),
      xlab = "Period",
      ylab = "Total customers",
      border = F
    )
    lines(x = bar, y = baseline, col = "#7d7d7d", type = "l", lty=2, lwd=2)
    text(2, baseline[5]+10, labels = c("Base line*"), col = "#7d7d7d")
    legend(
      "topleft",
      legend= c("Historical customers","Existing customers","New customers in period","Total new customer of previous periods after churn"),
      fill = c("#dedede","#d93954","#ffb600","#eb8c00"),
      bty="n",
      border = F
    )
  }
  
  
   
  output$distBeta <- renderPlot({
    alpha <- (input$brand * input$employer * input$technology)/3 * 10
    # generate bins based on input$bins from ui.R
    x <- rbeta(n=input$bins, shape1=alpha, shape2=14)
    # draw the histogram with the specified number of bins
    hist(x, breaks = 30, col = '#eb8c00', border = "white", main="Customer Churn")
  })
  
  output$distWeibull <- renderPlot({
    k <- (input$brand * (input$employer + input$technology)/2)
    # generate bins based on input$bins from ui.R
    x <- rweibull(n=input$bins, scale=k, shape=20)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = 30, col = '#eb8c00', border = "white", main="Customer Acquisition")
  })
  
  output$linePopulation <- renderPlot({
    # draw the histogram with the specified number of bins
    Total <- input$population * (1 + input$growth/100)^(0:30)
    Weeks <- 0:30
    plot(Weeks, Total, type = "b", main="Population Development")
  })
  
  output$Customer <- renderPlot({
    customerPlot(input$population,
                 input$growth/100,
                 input$customer,
                 input$brand,
                 input$employer,
                 input$technology)
  })
  
  output$Test <- renderPlot({
    ### Event Listener
    changeListener <- input$growth * input$customer * input$brand * input$employer * input$technology * input$customer
    
    ### Simulations
    infM <- (1 + input$priceInflation / 100) ^ (0:30)
    simPrice <- ((rbeta(input$nbSim, 2.5, 5 / (input$increaseSpending*10)) * input$avgSpending*0.2 - input$avgSpending*0.1) + input$avgSpending)
    all <- list()
    for(i in 1:input$nbSim){
      all[[i]] <- c(customerTotal[1:6] * input$avgSpending * input$avgOrder, customerTotal[7:36]*infM[2:31]*simPrice[i])  
    }
    
    allSim <- rep(0, 36)
    for(i in 1:length(all)) {
      for(j in 1:length(all[[i]])){
        if (j > 6){
          all[[i]][j] = all[[i]][j] * mean(rpois(10, input$avgOrder * input$increaseRate))
        }
        allSim[j] = allSim[j] + all[[i]][j]
      }
    }
    
    avgSim <- allSim / input$nbSim / 1000
    
    plot(x = -5:30, y = avgSim, type="l", lty=0, ylim=c(0, max(avgSim)*1.5), bty="n", xlab = "Period", ylab = "Revenue k",)
    
    for(i in 1:length(all)) {
      lines(x = -5:30, y = all[[i]] / 1000, col="#ffdca9")
    }
    lines(x = -5:0, y=avgSim[1:6], col="#dedede", lwd=5)
    lines(x = 0:30, y=avgSim[6:36], col="#eb8c00", lwd=5)
    
    baseline <- c(customerTotal[6:36] * input$avgSpending * input$avgOrder * infM)
    lines(x = 0:30, y = baseline / 1000, col = "#7d7d7d", type = "l", lty=2, lwd=2)
    text(30, baseline[30] /1000 -10, labels = c("Base line*"), col = "#7d7d7d")

    #plot(x = -5:30, y = customerTotal, frame.plot=FALSE)
  })
})
