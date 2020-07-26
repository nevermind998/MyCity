using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Data;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.DAL
{
    public class ReportKomentaraDAL : IReportKomentaraDAL
    {
        private readonly ApplicationDbContext _context;

        public ReportKomentaraDAL(ApplicationDbContext context)
        {
            _context = context;
        }

        public List<ReportKomentari> getAllReport()
        {
            return _context.reportKomentari.ToList();
        }

        public void deleteReportoveKomentara(List<ReportKomentari> reportovi)
        {
            if (reportovi != null)
            {
                _context.reportKomentari.RemoveRange(reportovi);
                _context.SaveChanges();
            }
        }

        public void saveReport(ReportKomentari data)
        {
            var check = _context.reportKomentari.FirstOrDefault(l => l.KorisnikID == data.KorisnikID && l.KomentarID == data.KomentarID);
            if (check != null)  //unreport
            {
                _context.reportKomentari.Remove(check);
            }
            else //report
            {
                var checkLajk = _context.lajkoviKomentari.FirstOrDefault(l => l.KorisnikID == data.KorisnikID && l.KomentarID == data.KomentarID);
                if (checkLajk != null)
                {
                    _context.lajkoviKomentari.Remove(checkLajk);
                }
                var checkDislajkovi = _context.dislajkoviKomentari.FirstOrDefault(l => l.KorisnikID == data.KorisnikID && l.KomentarID == data.KomentarID);
                if (checkDislajkovi != null)
                {
                    _context.dislajkoviKomentari.Remove(checkDislajkovi);
                }
                ReportKomentari report = data;
                var id = _context.reportKomentari.Count();
                if (id == 0)
                {
                    report.id = _context.reportKomentari.Count() + 1;
                }
                else
                {
                    report.id = _context.reportKomentari.Max(o => o.id) + 1;
                }
                _context.reportKomentari.Add(report);
            }
            _context.SaveChanges();
        }


        public int getReportKomentaraByIdKorisnika(long idKorisnika, long idKomentara)
        {
            var check = _context.reportKomentari.FirstOrDefault(l => l.KomentarID == idKomentara && l.KorisnikID == idKorisnika);
            if (check != null) return 1;
            else
            {
                return 0;
            }
        }
    }
}
