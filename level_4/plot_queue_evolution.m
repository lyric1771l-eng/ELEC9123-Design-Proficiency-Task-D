function plot_queue_evolution(time_vec, queue_len_vec, title_str)
    % Queue Length Over Time
    figure('Name','Queue Length Over Time','Color','w');
    plot(time_vec, queue_len_vec, 'b-', 'LineWidth', 1.5);
    xlabel('Time(min)');
    ylabel('Queue Length');
    title(title_str);
    grid on;
end
